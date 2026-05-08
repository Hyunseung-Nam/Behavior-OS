import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/repository_providers.dart';
import '../../../schedule/domain/entities/schedule_entity.dart';

part 'focus_controller.g.dart';

/// 오늘 완료한 일정 개수 스트림
@riverpod
Stream<int> todayCompletedCount(TodayCompletedCountRef ref) {
  final today = DateTime.now();
  return ref
      .watch(scheduleRepositoryProvider)
      .watchSchedules()
      .map((schedules) => schedules.where((s) {
            if (s.status != ScheduleStatus.completed) return false;
            if (s.completedAt == null) return false;
            final c = s.completedAt!;
            return c.year == today.year &&
                c.month == today.month &&
                c.day == today.day;
          }).length);
}

/// Focus 화면 컨트롤러
///
/// 역할: 현재 액션이 필요한 단 1개의 일정만 노출.
/// 우선순위: active(Nagging 중) > snoozed(연기 만료) > 다음 pending
/// 책임: 완료 / 연기 처리, syncStatuses() 호출 (상태 동기화)
@riverpod
class FocusController extends _$FocusController {
  @override
  Stream<ScheduleEntity?> build() {
    // 빌드 시 상태 동기화 (pending→active, missed 처리)
    ref.read(scheduleRepositoryProvider).syncStatuses();

    return ref
        .watch(scheduleRepositoryProvider)
        .watchSchedules()
        .map(_pickMostUrgent);
  }

  /// 가장 시급한 일정 선택 로직
  ///
  /// 우선순위:
  ///   1. active (알람이 울렸고 응답 대기 중)
  ///   2. snoozed이지만 snoozedUntil이 지난 것
  ///   3. null (지금 당장 해야 할 것 없음)
  ScheduleEntity? _pickMostUrgent(List<ScheduleEntity> schedules) {
    final now = DateTime.now();

    // 1순위: active
    final active = schedules
        .where((s) => s.status == ScheduleStatus.active)
        .toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    if (active.isNotEmpty) return active.first;

    // 2순위: snoozed 만료
    final snoozedExpired = schedules
        .where((s) =>
            s.status == ScheduleStatus.snoozed &&
            s.snoozedUntil != null &&
            now.isAfter(s.snoozedUntil!))
        .toList()
      ..sort((a, b) => a.snoozedUntil!.compareTo(b.snoozedUntil!));
    if (snoozedExpired.isNotEmpty) return snoozedExpired.first;

    // 3순위: 30분 이내 pending (예고 표시)
    final upcoming = schedules
        .where((s) =>
            s.status == ScheduleStatus.pending &&
            now.isAfter(
                s.scheduledAt.subtract(const Duration(minutes: 30))))
        .toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    if (upcoming.isNotEmpty) return upcoming.first;

    return null;
  }

  /// 행동 완료 처리
  ///
  /// Args:
  ///   scheduleId: 완료할 일정 ID
  /// Side Effects: 알림 전부 취소, DB 상태 → completed
  Future<void> complete(String scheduleId) async {
    await ref.read(scheduleRepositoryProvider).completeSchedule(scheduleId);
  }

  /// 10분 연기 처리
  ///
  /// Args:
  ///   scheduleId: 연기할 일정 ID
  /// Side Effects: Nagging 알림 취소, 10분 후 재알림 등록, DB 상태 → snoozed
  Future<void> snooze(String scheduleId) async {
    await ref.read(scheduleRepositoryProvider).snoozeSchedule(scheduleId);
  }
}
