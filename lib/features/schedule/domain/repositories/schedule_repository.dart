import '../entities/schedule_entity.dart';

/// 일정 Repository 인터페이스
///
/// 역할: Domain 레이어가 Data 레이어에 의존하지 않도록 추상화.
/// 구현체: ScheduleRepositoryImpl (data 레이어)
abstract class ScheduleRepository {
  /// 전체 일정 스트림 (Supabase Realtime 또는 로컬 DB 변경 시 갱신)
  Stream<List<ScheduleEntity>> watchSchedules();

  /// 단일 일정 조회
  Future<ScheduleEntity?> getSchedule(String id);

  /// 일정 생성 + 알림 스케줄링
  Future<ScheduleEntity> createSchedule({
    required String title,
    String? description,
    String? why,
    String? minimumAction,
    required ScheduleCategory category,
    required DateTime scheduledAt,
  });

  /// 일정 완료 처리 + 모든 Nagging 알림 취소
  Future<void> completeSchedule(String id);

  /// 10분 연기 처리 + 기존 Nagging 취소 + 재스케줄링
  Future<void> snoozeSchedule(String id);

  /// 놓친 일정 목록 조회
  Future<List<ScheduleEntity>> getMissedSchedules();

  /// 일정 수정 (제목/내용/시각 변경 + 알림/캘린더 재등록)
  Future<void> updateSchedule(
    String id, {
    required String title,
    String? why,
    String? minimumAction,
    required ScheduleCategory category,
    required DateTime scheduledAt,
  });

  /// 놓친 일정 재스케줄링
  Future<ScheduleEntity> rescheduleSchedule(
      String id, DateTime newScheduledAt);

  /// 일정 삭제 + 관련 알림 전부 취소
  Future<void> deleteSchedule(String id);

  /// pending/active/snoozed 상태 일정을 현재 시간 기준으로 동기화
  ///
  /// - pending → active: scheduledAt 도래 시
  /// - pending/active/snoozed → missed: scheduledAt + 60분 초과 시
  Future<void> syncStatuses();
}
