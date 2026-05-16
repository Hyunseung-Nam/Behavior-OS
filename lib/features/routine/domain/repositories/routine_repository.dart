import '../entities/routine_entity.dart';

/// 루틴 Repository 인터페이스
///
/// 역할: Domain 레이어가 Data 레이어에 의존하지 않도록 추상화.
/// 구현체: RoutineRepositoryImpl
abstract class RoutineRepository {
  /// 루틴 목록 스트림 (DB 변경 시 자동 갱신)
  Stream<List<RoutineEntity>> watchRoutines();

  /// 루틴 추가 + 알림 등록
  Future<void> addRoutine({
    required String title,
    required int notifyHour,
    required int notifyMinute,
  });

  /// 루틴 수정 + 알림 재등록
  Future<void> updateRoutine(
    String id, {
    required String title,
    required int notifyHour,
    required int notifyMinute,
  });

  /// 루틴 on/off 토글 + 알림 등록/취소
  Future<void> toggleRoutine(String id, bool isEnabled);

  /// 루틴 삭제 + 알림 취소
  Future<void> deleteRoutine(String id);
}
