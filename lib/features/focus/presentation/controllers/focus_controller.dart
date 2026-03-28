import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../schedule/domain/entities/schedule_entity.dart';
import '../../../schedule/domain/repositories/schedule_repository.dart';

part 'focus_controller.g.dart';

/// Focus 화면 컨트롤러
///
/// 역할: 현재 액션이 필요한 단 1개의 일정만 노출.
/// 우선순위: active(Nagging 중) > snoozed(연기 만료) > 다음 pending
/// 책임: 완료 / 연기 처리만 담당 (비즈니스 로직은 Repository에 위임)
@riverpod
class FocusController extends _$FocusController {
  @override
  Stream<ScheduleEntity?> build() {
    // 모든 일정 스트림에서 가장 시급한 1개만 추출
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
  ///   3. 가장 가까운 pending
  ScheduleEntity? _pickMostUrgent(List<ScheduleEntity> schedules) {
    final now = DateTime.now();

    final active = schedules
        .where((s) => s.status == ScheduleStatus.active)
        .toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    if (active.isNotEmpty) return active.first;

    final snoozedExpired = schedules
        .where((s) =>
            s.status == ScheduleStatus.snoozed &&
            s.snoozedUntil != null &&
            now.isAfter(s.snoozedUntil!))
        .toList()
      ..sort((a, b) => a.snoozedUntil!.compareTo(b.snoozedUntil!));
    if (snoozedExpired.isNotEmpty) return snoozedExpired.first;

    return null; // 지금 당장 해야 할 것 없음
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

// Provider 선언 (임시 - 실제 구현체로 교체 필요)
final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  throw UnimplementedError('ScheduleRepositoryImpl 등록 필요');
});
