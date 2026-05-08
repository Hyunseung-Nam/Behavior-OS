import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../core/constants/app_constants.dart';
import '../../features/schedule/domain/entities/schedule_entity.dart';
import '../database/app_database.dart';

/// 알림 타입
enum NotificationType { earlyReminder, prepReminder, trigger, nagging }

/// 로컬 알림 서비스 (싱글톤)
///
/// 역할: flutter_local_notifications 래퍼. 모든 알림 CRUD 담당.
/// 책임:
///   - 알림 채널 초기화 (Android) + 권한 요청 (iOS)
///   - 다단계 알림 스케줄링 (30분 전, 10분 전, 정각)
///   - Nagging 알림 선(先)스케줄링 (5분 간격 x12)
///   - 알림 ID 체계 관리 및 취소
/// 외부 의존성: flutter_local_notifications, timezone
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  // 알림 ID 체계: scheduleId.hashCode % 100000 * 100 + offset
  // offset: 0=early(30분전), 1=prep(10분전), 2=trigger(정각), 11~22=nagging
  static int _id(String scheduleId, int offset) =>
      scheduleId.hashCode.abs() % 100000 * 100 + offset;

  /// 플러그인 초기화 + iOS 알림 권한 요청
  ///
  /// Returns: Future<bool> — 권한 허용 여부
  /// Side Effects: Android 채널 생성, iOS 권한 다이얼로그 표시
  Future<bool> initialize() async {
    if (_initialized) return true;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // 잠금화면 알림 액션 버튼 정의 (완료)
    final completeAction = DarwinNotificationAction.plain(
      AppConstants.notificationActionComplete,
      '행동 완료',
    );
    final scheduleCategory = DarwinNotificationCategory(
      AppConstants.notificationCategorySchedule,
      actions: [completeAction],
    );

    final iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      notificationCategories: [scheduleCategory],
    );

    final result = await _plugin.initialize(
      InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
        macOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundTapped,
    );

    // Android O+ 알림 채널 생성
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

    // iOS 추가 권한 요청 (명시적)
    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    _initialized = result ?? false;
    return _initialized;
  }

  /// 일정에 대한 다단계 알림 전체 스케줄링
  ///
  /// 등록 알림 목록:
  ///   - T-30분: "30분 후 [title] 예정"
  ///   - T-10분: "10분 후 [title] 준비하세요"
  ///   - T+0:   "🚨 지금 바로 [title] 시작하세요"
  ///   - T+5 ~ T+60: Nagging 12개 (5분 간격)
  ///
  /// Args:
  ///   schedule: 스케줄링할 일정 엔티티
  /// Returns: Future<void>
  /// Side Effects: 최대 15개의 로컬 알림 등록
  Future<void> scheduleAll(ScheduleEntity schedule) async {
    if (defaultTargetPlatform == TargetPlatform.macOS) return;
    final now = tz.TZDateTime.now(tz.local);

    // T-30분 인지 알림
    await _scheduleIfFuture(
      id: _id(schedule.id, 0),
      title: '30분 후 예정',
      body: schedule.title,
      scheduledAt: tz.TZDateTime.from(schedule.earlyReminderAt, tz.local),
      now: now,
      payload: _payload(schedule.id, NotificationType.earlyReminder),
    );

    // T-10분 준비 알림
    await _scheduleIfFuture(
      id: _id(schedule.id, 1),
      title: '10분 후 시작',
      body: '${schedule.title} — 지금 준비하세요',
      scheduledAt: tz.TZDateTime.from(schedule.prepReminderAt, tz.local),
      now: now,
      payload: _payload(schedule.id, NotificationType.prepReminder),
    );

    // T+0 트리거 알림
    await _scheduleIfFuture(
      id: _id(schedule.id, 2),
      title: '🚨 지금 바로 시작하세요',
      body: schedule.title,
      scheduledAt: tz.TZDateTime.from(schedule.triggerAt, tz.local),
      now: now,
      payload: _payload(schedule.id, NotificationType.trigger),
    );

    // Nagging 12개 (T+5 ~ T+60)
    for (int i = 1; i <= AppConstants.maxPrescheduledNagging; i++) {
      await _scheduleIfFuture(
        id: _id(schedule.id, 10 + i),
        title: '⚠️ 아직 완료하지 않았어요',
        body: '${schedule.title} — 완료 또는 연기해 주세요',
        scheduledAt: tz.TZDateTime.from(schedule.naggingAt(i), tz.local),
        now: now,
        payload: _payload(schedule.id, NotificationType.nagging),
      );
    }
  }

  /// 특정 일정의 모든 알림 취소 (완료 / 삭제 시)
  ///
  /// Args:
  ///   scheduleId: 취소할 일정 ID
  Future<void> cancelAll(String scheduleId) async {
    if (defaultTargetPlatform == TargetPlatform.macOS) return;
    final ids = [
      _id(scheduleId, 0),
      _id(scheduleId, 1),
      _id(scheduleId, 2),
      for (int i = 1; i <= AppConstants.maxPrescheduledNagging; i++)
        _id(scheduleId, 10 + i),
    ];
    for (final id in ids) {
      await _plugin.cancel(id);
    }
  }

  /// Nagging 알림만 취소 (Snooze 시)
  ///
  /// Args:
  ///   scheduleId: 대상 일정 ID
  Future<void> cancelNagging(String scheduleId) async {
    if (defaultTargetPlatform == TargetPlatform.macOS) return;
    for (int i = 1; i <= AppConstants.maxPrescheduledNagging; i++) {
      await _plugin.cancel(_id(scheduleId, 10 + i));
    }
  }

  /// Snooze 후 단일 알림 등록 (n분 후 재트리거)
  ///
  /// Args:
  ///   scheduleId: 대상 일정 ID
  ///   title: 알림 제목
  ///   delayMinutes: 몇 분 후 알림 (기본 10분)
  Future<void> scheduleSnoozeReminder({
    required String scheduleId,
    required String title,
    int delayMinutes = 10,
  }) async {
    final scheduledAt =
        tz.TZDateTime.now(tz.local).add(Duration(minutes: delayMinutes));

    await _plugin.zonedSchedule(
      _id(scheduleId, 3), // offset 3 = snooze 전용
      '⏰ 연기된 행동',
      '$title — 이제 시작할 시간이에요',
      scheduledAt,
      _notificationDetails(
          payload: _payload(scheduleId, NotificationType.trigger)),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: _payload(scheduleId, NotificationType.trigger),
    );
  }

  // ─────────────────────────────────────────
  // Private helpers
  // ─────────────────────────────────────────

  Future<void> _scheduleIfFuture({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledAt,
    required tz.TZDateTime now,
    required String payload,
  }) async {
    if (scheduledAt.isBefore(now)) return;

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduledAt,
      _notificationDetails(payload: payload),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  NotificationDetails _notificationDetails({required String payload}) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        AppConstants.notificationChannelId,
        AppConstants.notificationChannelName,
        channelDescription: AppConstants.notificationChannelDesc,
        importance: Importance.max,
        priority: Priority.high,
        fullScreenIntent: true,
        category: AndroidNotificationCategory.alarm,
        styleInformation: const BigTextStyleInformation(''),
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.active,
        categoryIdentifier: AppConstants.notificationCategorySchedule,
      ),
    );
  }

  String _payload(String scheduleId, NotificationType type) =>
      '$scheduleId:${type.name}';

  void _onNotificationTapped(NotificationResponse response) {
    if (response.actionId == AppConstants.notificationActionComplete) {
      _handleCompleteAction(response.payload);
    }
    // 일반 탭: GoRouter 딥링크 연동 예정
  }
}

/// 잠금화면 "행동 완료" 액션 처리
///
/// payload 형식: "scheduleId:notificationType"
/// Side Effects: DB 상태 → completed, 관련 알림 전부 취소
Future<void> _handleCompleteAction(String? payload) async {
  if (payload == null) return;
  final scheduleId = payload.split(':').first;
  if (scheduleId.isEmpty) return;

  final db = AppDatabase();
  final now = DateTime.now();

  await (db.update(db.scheduleTable)..where((t) => t.id.equals(scheduleId)))
      .write(ScheduleTableCompanion(
    status: const Value('completed'),
    completedAt: Value(now),
    updatedAt: Value(now),
  ));

  await db.close();
  await NotificationService.instance.cancelAll(scheduleId);
}

/// 백그라운드 알림 탭 핸들러 (top-level 함수 필수, 별도 isolate에서 실행)
@pragma('vm:entry-point')
void _onBackgroundTapped(NotificationResponse response) {
  if (response.actionId == AppConstants.notificationActionComplete) {
    tz_data.initializeTimeZones();
    _handleCompleteAction(response.payload);
  }
}
