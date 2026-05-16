import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/repository_providers.dart';
import '../../domain/entities/routine_entity.dart';

/// 루틴 목록 컨트롤러
///
/// 역할: 루틴 스트림 노출 + CRUD 처리.
/// 책임: UI 흐름 제어만 담당. 비즈니스 로직은 Repository에 위임.
/// 외부 의존성: RoutineRepository (routineRepositoryProvider)
class RoutineController extends StreamNotifier<List<RoutineEntity>> {
  @override
  Stream<List<RoutineEntity>> build() {
    return ref.watch(routineRepositoryProvider).watchRoutines();
  }

  /// 루틴 추가
  ///
  /// Side Effects: DB 저장, 매일 반복 알림 등록
  Future<void> add({
    required String title,
    required int notifyHour,
    required int notifyMinute,
  }) async {
    await ref.read(routineRepositoryProvider).addRoutine(
          title: title,
          notifyHour: notifyHour,
          notifyMinute: notifyMinute,
        );
  }

  /// 루틴 수정
  ///
  /// Side Effects: DB 갱신, 기존 알림 취소 후 재등록
  Future<void> edit(
    String id, {
    required String title,
    required int notifyHour,
    required int notifyMinute,
  }) async {
    await ref.read(routineRepositoryProvider).updateRoutine(
          id,
          title: title,
          notifyHour: notifyHour,
          notifyMinute: notifyMinute,
        );
  }

  /// 루틴 on/off 토글
  ///
  /// Side Effects: DB 갱신, 알림 등록 또는 취소
  Future<void> toggle(String id, bool isEnabled) async {
    await ref.read(routineRepositoryProvider).toggleRoutine(id, isEnabled);
  }

  /// 루틴 삭제
  ///
  /// Side Effects: DB 삭제, 관련 알림 취소
  Future<void> delete(String id) async {
    await ref.read(routineRepositoryProvider).deleteRoutine(id);
  }
}

/// 루틴 컨트롤러 Provider
final routineControllerProvider =
    StreamNotifierProvider<RoutineController, List<RoutineEntity>>(
  RoutineController.new,
);
