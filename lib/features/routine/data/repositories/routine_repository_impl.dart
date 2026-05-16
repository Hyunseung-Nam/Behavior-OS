import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../../shared/database/app_database.dart';
import '../../../../shared/services/notification_service.dart';
import '../../domain/entities/routine_entity.dart';
import '../../domain/repositories/routine_repository.dart';

/// 루틴 Repository 구현체 (Drift SQLite)
///
/// 역할: Drift 기반 로컬 SQLite 저장소 + 알림 서비스 연동.
/// 책임:
///   - 루틴 CRUD (Drift ORM)
///   - 추가/수정/토글 시 NotificationService 연동
/// 외부 의존성: AppDatabase, NotificationService
class RoutineRepositoryImpl implements RoutineRepository {
  RoutineRepositoryImpl(this._db);

  final AppDatabase _db;
  final _uuid = const Uuid();

  @override
  Stream<List<RoutineEntity>> watchRoutines() {
    return (_db.select(_db.routineTable)
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .watch()
        .map((rows) => rows.map(_toEntity).toList());
  }

  @override
  Future<void> addRoutine({
    required String title,
    required int notifyHour,
    required int notifyMinute,
  }) async {
    final now = DateTime.now();
    final id = _uuid.v4();

    await _db.into(_db.routineTable).insert(
          RoutineTableCompanion.insert(
            id: id,
            title: title,
            notifyHour: notifyHour,
            notifyMinute: notifyMinute,
            createdAt: now,
            updatedAt: now,
          ),
        );

    await NotificationService.instance.scheduleDailyRoutine(
      routineId: id,
      title: title,
      hour: notifyHour,
      minute: notifyMinute,
    );
  }

  @override
  Future<void> updateRoutine(
    String id, {
    required String title,
    required int notifyHour,
    required int notifyMinute,
  }) async {
    // 기존 알림 취소 후 재등록
    await NotificationService.instance.cancelDailyRoutine(id);

    await (_db.update(_db.routineTable)..where((t) => t.id.equals(id)))
        .write(RoutineTableCompanion(
      title: Value(title),
      notifyHour: Value(notifyHour),
      notifyMinute: Value(notifyMinute),
      updatedAt: Value(DateTime.now()),
    ));

    // isEnabled인 경우에만 재등록
    final row = await (_db.select(_db.routineTable)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    if (row.isEnabled) {
      await NotificationService.instance.scheduleDailyRoutine(
        routineId: id,
        title: title,
        hour: notifyHour,
        minute: notifyMinute,
      );
    }
  }

  @override
  Future<void> toggleRoutine(String id, bool isEnabled) async {
    await (_db.update(_db.routineTable)..where((t) => t.id.equals(id)))
        .write(RoutineTableCompanion(
      isEnabled: Value(isEnabled),
      updatedAt: Value(DateTime.now()),
    ));

    if (isEnabled) {
      final row = await (_db.select(_db.routineTable)
            ..where((t) => t.id.equals(id)))
          .getSingle();
      await NotificationService.instance.scheduleDailyRoutine(
        routineId: id,
        title: row.title,
        hour: row.notifyHour,
        minute: row.notifyMinute,
      );
    } else {
      await NotificationService.instance.cancelDailyRoutine(id);
    }
  }

  @override
  Future<void> deleteRoutine(String id) async {
    await NotificationService.instance.cancelDailyRoutine(id);
    await (_db.delete(_db.routineTable)..where((t) => t.id.equals(id))).go();
  }

  /// DB 행 → 도메인 엔티티 변환
  ///
  /// Args:
  ///   row: Drift가 반환한 RoutineTableData
  /// Returns: RoutineEntity
  RoutineEntity _toEntity(RoutineTableData row) {
    return RoutineEntity(
      id: row.id,
      title: row.title,
      notifyHour: row.notifyHour,
      notifyMinute: row.notifyMinute,
      isEnabled: row.isEnabled,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
