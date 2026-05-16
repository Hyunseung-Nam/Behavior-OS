import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/repository_providers.dart';
import '../../domain/entities/schedule_entity.dart';

part 'schedule_controller.g.dart';

/// 일정 목록 컨트롤러
///
/// 역할: 전체 일정 스트림 노출 + 삭제 처리.
/// 책임: UI에 데이터 제공, 흐름 제어만 담당. 비즈니스 로직은 Repository에 위임.
/// 외부 의존성: ScheduleRepository (scheduleRepositoryProvider)
@riverpod
class ScheduleController extends _$ScheduleController {
  @override
  Stream<List<ScheduleEntity>> build() {
    return ref.watch(scheduleRepositoryProvider).watchSchedules();
  }

  /// 일정 생성
  ///
  /// Args:
  ///   title: 일정 제목
  ///   description: 부가 설명 (선택)
  ///   scheduledAt: 예정 시각
  /// Side Effects: 알림 스케줄링, DB 저장, 스트림 갱신
  /// Raises: Exception — 저장 실패 시
  Future<void> create({
    required String title,
    String? description,
    String? why,
    String? minimumAction,
    required ScheduleCategory category,
    required DateTime scheduledAt,
  }) async {
    await ref.read(scheduleRepositoryProvider).createSchedule(
          title: title,
          description: description,
          why: why,
          minimumAction: minimumAction,
          category: category,
          scheduledAt: scheduledAt,
        );
  }

  /// 일정 수정
  ///
  /// Args:
  ///   id: 수정할 일정 ID
  ///   title, why, minimumAction, category, scheduledAt: 변경할 값
  /// Side Effects: 기존 알림/캘린더 취소 후 재등록, DB 갱신, 스트림 갱신
  Future<void> edit({
    required String id,
    required String title,
    String? why,
    String? minimumAction,
    required ScheduleCategory category,
    required DateTime scheduledAt,
  }) async {
    await ref.read(scheduleRepositoryProvider).updateSchedule(
          id,
          title: title,
          why: why,
          minimumAction: minimumAction,
          category: category,
          scheduledAt: scheduledAt,
        );
  }

  /// 일정 삭제
  ///
  /// Args:
  ///   id: 삭제할 일정 ID
  /// Side Effects: 관련 알림 전부 취소, DB에서 제거, 스트림 갱신
  Future<void> delete(String id) async {
    await ref.read(scheduleRepositoryProvider).deleteSchedule(id);
  }
}
