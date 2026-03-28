import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../core/constants/app_constants.dart';
import '../../features/schedule/domain/entities/schedule_entity.dart';

/// 알림 타입
enum NotificationType { earlyReminder, prepReminder, trigger, nagging }

/// 로컬 알림 서비스 (싱글톤)
///
/// 역할: flutter_local_notifications 래퍼. 모든 알림 CRUD 담당.
/// 책임:
///   - 알림 채널 초기화 (Android)
///   - 다단계 알림 스케줄링 (30분 전, 10분 전, 정각)
///   - Nagging 알림 선(先)스케줄링
///   - 알림 ID 체계 관리
/// 외부 의존성: flutter_local_notifications, timezone
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // 알림 ID 체계: scheduleHashCode * 100 + offset
  // offset: 0=early, 1=prep, 2=trigger, 10~22=nagging(최대 12개)
  static int _notificationId(String scheduleId, int offset) =>
      scheduleId.hashCode.abs() % 100000 * 100 + offset;

  /// 플러그인 초기화
  ///
  /// Args: 없음
  /// Returns: Future<void>
  /// Side Effects: Android 알림 채널 생성, iOS 권한 요청
  /// Raises: Exception (초기화 실패 시)
  Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundNotificationTapped,
    );

    // Android O+ 채널 생성
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            AppConstants.notificationChannelId,
            AppConstants.notificationChannelName,
            description: AppConstants.notificationChannelDesc,
            importance: Importance.max,
            playSound: true,
            enableVibration: true,
            enableLights: true,
          ),
        );
  }

  /// 일정에 대한 다단계 알림 전체 스케줄링
  ///
  /// 스케줄링 내용:
  ///   - T-30분: 인지 알림
  ///   - T-10분: 준비 알림
  ///   - T+0: 행동 트리거 알림
  ///   - T+5, T+10 ... T+60: Nagging 12개 선(先)스케줄
  ///
  /// Args:
  ///   schedule: 스케줄링할 일정 엔티티
  /// Returns: Future<void>
  /// Side Effects: 최대 15개의 로컬 알림 등록
  Future<void> scheduleAllNotifications(ScheduleEntity schedule) async {
    final now = tz.TZDateTime.now(tz.local);

    // 30분 전 인지 알림
    await _scheduleIfFuture(
      id: _notificationId(schedule.id, 0),
      title: '30분 후 예정',
      body: '${schedule.title} - 잊지 마세요',
      scheduledAt: tz.TZDateTime.from(schedule.earlyReminderAt, tz.local),
      now: now,
      payload: '${schedule.id}:${NotificationType.earlyReminder.name}',
    );

    // 10분 전 준비 알림
    await _scheduleIfFuture(
      id: _notificationId(schedule.id, 1),
      title: '10분 후 시작',
      body: '${schedule.title} - 준비하세요',
      scheduledAt: tz.TZDateTime.from(schedule.prepReminderAt, tz.local),
      now: now,
      payload: '${schedule.id}:${NotificationType.prepReminder.name}',
    );

    // 정각 트리거 알림
    await _scheduleIfFuture(
      id: _notificationId(schedule.id, 2),
      title: '🚨 지금 바로 시작하세요',
      body: schedule.title,
      scheduledAt: tz.TZDateTime.from(schedule.triggerAt, tz.local),
      now: now,
      payload: '${schedule.id}:${NotificationType.trigger.name}',
    );

    // Nagging 12개 (5분 간격, 최대 60분)
    for (int i = 1; i <= AppConstants.maxPrescheduledNagging; i++) {
      await _scheduleIfFuture(
        id: _notificationId(schedule.id, 10 + i),
        title: '⚠️ 아직 완료 안 했어요',
        body: '${schedule.title} - 완료 또는 연기해 주세요',
        scheduledAt: tz.TZDateTime.from(schedule.naggingAt(i), tz.local),
        now: now,
        payload: '${schedule.id}:${NotificationType.nagging.name}',
      );
    }
  }

  /// 특정 일정의 모든 알림 취소 (완료/삭제 시 호출)
  ///
  /// Args:
  ///   scheduleId: 취소할 일정 ID
  /// Returns: Future<void>
  /// Side Effects: 해당 일정의 알림 15개 전부 취소
  Future<void> cancelAllNotifications(String scheduleId) async {
    final ids = [
      _notificationId(scheduleId, 0), // early
      _notificationId(scheduleId, 1), // prep
      _notificationId(scheduleId, 2), // trigger
      for (int i = 1; i <= AppConstants.maxPrescheduledNagging; i++)
        _notificationId(scheduleId, 10 + i), // nagging
    ];
    for (final id in ids) {
      await _plugin.cancel(id);
    }
  }

  /// Nagging 알림만 취소 (Snooze 시 호출)
  ///
  /// Args:
  ///   scheduleId: 대상 일정 ID
  Future<void> cancelNaggingNotifications(String scheduleId) async {
    for (int i = 1; i <= AppConstants.maxPrescheduledNagging; i++) {
      await _plugin.cancel(_notificationId(scheduleId, 10 + i));
    }
  }

  // ──────────────────────────────────────────
  // Private helpers
  // ──────────────────────────────────────────

  Future<void> _scheduleIfFuture({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledAt,
    required tz.TZDateTime now,
    required String payload,
  }) async {
    if (scheduledAt.isBefore(now)) return; // 과거 시간은 스킵

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduledAt,
      NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.notificationChannelId,
          AppConstants.notificationChannelName,
          channelDescription: AppConstants.notificationChannelDesc,
          importance: Importance.max,
          priority: Priority.high,
          fullScreenIntent: true, // 화면이 꺼져 있어도 알림 표시
          category: AndroidNotificationCategory.alarm,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          interruptionLevel: InterruptionLevel.timeSensitive,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    // TODO: GoRouter를 통해 Focus 화면으로 이동
    // NavigationService.instance.navigateTo('/focus/${payload}');
  }
}

/// 백그라운드 알림 탭 핸들러 (top-level 함수 필수)
@pragma('vm:entry-point')
void _onBackgroundNotificationTapped(NotificationResponse response) {
  // 백그라운드에서 탭 시 처리
}
