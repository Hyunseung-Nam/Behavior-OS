import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_entity.freezed.dart';

/// 일정 상태 열거형
///
/// - pending: 아직 알림이 울리지 않은 상태
/// - active: 알림이 울렸고, 사용자 응답 대기 중 (Nagging 진행 중)
/// - snoozed: 10분 연기됨
/// - completed: 사용자가 [행동 완료] 선택
/// - missed: 시간 초과, 미완료 보관함으로 이동
enum ScheduleStatus { pending, active, snoozed, completed, missed }

/// 일정 카테고리 열거형
///
/// FocusPage 포인트 컬러 및 아이콘 결정에 사용.
enum ScheduleCategory {
  study,    // 공부
  exercise, // 운동
  work,     // 업무
  rest,     // 휴식
  other,    // 기타
}

/// 핵심 도메인 엔티티: 일정
///
/// 역할: 순수 비즈니스 규칙 보유. Flutter 의존성 없음.
/// 책임:
///   - 알림 시간 계산 (30분 전, 10분 전, 정각)
///   - 상태 전이 규칙
@freezed
class ScheduleEntity with _$ScheduleEntity {
  const factory ScheduleEntity({
    required String id,
    required String userId,
    required String title,
    String? description,
    /// 이게 왜 중요한가 (선택 입력, FocusPage + 알림에 표시)
    String? why,
    /// 최소한 이것만 (선택 입력, FocusPage에서 시작 마찰 감소)
    String? minimumAction,
    /// 카테고리 (FocusPage 포인트 컬러 결정)
    @Default(ScheduleCategory.other) ScheduleCategory category,
    required DateTime scheduledAt,
    @Default(ScheduleStatus.pending) ScheduleStatus status,
    @Default(0) int naggingCount,
    DateTime? snoozedUntil,
    DateTime? completedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ScheduleEntity;

  const ScheduleEntity._();

  /// 30분 전 인지 알림 시각
  DateTime get earlyReminderAt =>
      scheduledAt.subtract(const Duration(minutes: 30));

  /// 10분 전 준비 알림 시각
  DateTime get prepReminderAt =>
      scheduledAt.subtract(const Duration(minutes: 10));

  /// 정각 알림 시각 (= scheduledAt)
  DateTime get triggerAt => scheduledAt;

  /// Nagging n번째 알림 시각
  DateTime naggingAt(int index) =>
      scheduledAt.add(Duration(minutes: 5 * index));

  /// 현재 시간 기준 놓친 일정 여부
  bool isMissed(DateTime now) =>
      status != ScheduleStatus.completed &&
      status != ScheduleStatus.missed &&
      now.isAfter(scheduledAt.add(const Duration(minutes: 60)));
}
