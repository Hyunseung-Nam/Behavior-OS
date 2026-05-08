import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/repository_providers.dart';
import '../../../schedule/domain/entities/schedule_entity.dart';

part 'missed_controller.g.dart';

/// 놓친 일정 컨트롤러
///
/// 역할: missed 상태 일정 스트림 노출 + 재스케줄링/삭제 처리.
/// 책임: UI 흐름 제어만 담당. 비즈니스 로직은 Repository에 위임.
/// 외부 의존성: ScheduleRepository (scheduleRepositoryProvider)
@riverpod
class MissedController extends _$MissedController {
  @override
  Stream<List<ScheduleEntity>> build() {
    return ref
        .watch(scheduleRepositoryProvider)
        .watchSchedules()
        .map((list) => list
            .where((s) => s.status == ScheduleStatus.missed)
            .toList()
          ..sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt)));
  }

  /// 놓친 일정 재스케줄링
  ///
  /// Args:
  ///   id: 재스케줄할 일정 ID
  ///   newScheduledAt: 새 예정 시각
  /// Side Effects: 알림 재등록, DB 상태 → pending, 스트림 갱신
  /// Raises: Exception — 일정이 존재하지 않을 때
  Future<void> reschedule(String id, DateTime newScheduledAt) async {
    await ref
        .read(scheduleRepositoryProvider)
        .rescheduleSchedule(id, newScheduledAt);
  }

  /// 놓친 일정 삭제
  ///
  /// Args:
  ///   id: 삭제할 일정 ID
  /// Side Effects: 관련 알림 취소, DB에서 제거, 스트림 갱신
  Future<void> delete(String id) async {
    await ref.read(scheduleRepositoryProvider).deleteSchedule(id);
  }
}
