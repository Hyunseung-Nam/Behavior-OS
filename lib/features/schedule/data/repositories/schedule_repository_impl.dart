import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../../shared/database/app_database.dart';
import '../../../../shared/services/notification_service.dart';
import '../../../../shared/services/background_service.dart';
import '../../domain/entities/schedule_entity.dart';
import '../../domain/repositories/schedule_repository.dart';

/// 일정 Repository 구현체 (Drift SQLite)
///
/// 역할: Drift 기반 로컬 SQLite 저장소 + 알림 서비스 연동.
/// 책임:
///   - 일정 CRUD (Drift ORM)
///   - 생성 시 NotificationService.scheduleAll() 호출
///   - 완료/연기 시 알림 취소 및 재스케줄
///   - Workmanager Nagging 작업 등록/취소
/// 외부 의존성: AppDatabase, NotificationService, BackgroundService
class ScheduleRepositoryImpl implements ScheduleRepository {
  ScheduleRepositoryImpl(this._db);

  final AppDatabase _db;
  final _uuid = const Uuid();

  // ─────────────────────────────────────────
  // 조회
  // ─────────────────────────────────────────

  @override
  Stream<List<ScheduleEntity>> watchSchedules() {
    return (_db.select(_db.scheduleTable)
          ..orderBy([(t) => OrderingTerm.asc(t.scheduledAt)]))
        .watch()
        .map((rows) => rows.map(_toEntity).toList());
  }

  @override
  Future<ScheduleEntity?> getSchedule(String id) async {
    final row = await (_db.select(_db.scheduleTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row != null ? _toEntity(row) : null;
  }

  @override
  Future<List<ScheduleEntity>> getMissedSchedules() async {
    final rows = await (_db.select(_db.scheduleTable)
          ..where((t) => t.status.equals(ScheduleStatus.missed.name)))
        .get();
    return rows.map(_toEntity).toList();
  }

  // ─────────────────────────────────────────
  // 쓰기
  // ─────────────────────────────────────────

  @override
  Future<ScheduleEntity> createSchedule({
    required String title,
    String? description,
    String? why,
    String? minimumAction,
    required ScheduleCategory category,
    required DateTime scheduledAt,
  }) async {
    final now = DateTime.now();
    final id = _uuid.v4();

    await _db.into(_db.scheduleTable).insert(
          ScheduleTableCompanion.insert(
            id: id,
            userId: 'local',
            title: title,
            description: Value(description),
            why: Value(why),
            minimumAction: Value(minimumAction),
            category: Value(category.name),
            scheduledAt: scheduledAt,
            status: const Value('pending'),
            naggingCount: const Value(0),
            createdAt: now,
            updatedAt: now,
          ),
        );

    final entity = (await getSchedule(id))!;

    // 다단계 알림 + Nagging 스케줄링
    await NotificationService.instance.scheduleAll(entity);

    // 60분 후 Workmanager 백그라운드 체크 등록
    await BackgroundService.registerNaggingTask(scheduleId: id);

    return entity;
  }

  @override
  Future<void> completeSchedule(String id) async {
    final now = DateTime.now();
    await (_db.update(_db.scheduleTable)..where((t) => t.id.equals(id)))
        .write(ScheduleTableCompanion(
      status: const Value('completed'),
      completedAt: Value(now),
      updatedAt: Value(now),
    ));

    await NotificationService.instance.cancelAll(id);
    await BackgroundService.cancelNaggingTask(id);
  }

  @override
  Future<void> snoozeSchedule(String id) async {
    final snoozedUntil = DateTime.now().add(const Duration(minutes: 10));
    await (_db.update(_db.scheduleTable)..where((t) => t.id.equals(id)))
        .write(ScheduleTableCompanion(
      status: const Value('snoozed'),
      snoozedUntil: Value(snoozedUntil),
      updatedAt: Value(DateTime.now()),
    ));

    final entity = await getSchedule(id);
    if (entity == null) return;

    await NotificationService.instance.cancelNagging(id);
    await NotificationService.instance.scheduleSnoozeReminder(
      scheduleId: id,
      title: entity.title,
    );
  }

  @override
  Future<ScheduleEntity> rescheduleSchedule(
      String id, DateTime newScheduledAt) async {
    await (_db.update(_db.scheduleTable)..where((t) => t.id.equals(id)))
        .write(ScheduleTableCompanion(
      scheduledAt: Value(newScheduledAt),
      status: const Value('pending'),
      naggingCount: const Value(0),
      snoozedUntil: const Value(null),
      updatedAt: Value(DateTime.now()),
    ));

    final entity = (await getSchedule(id))!;

    await NotificationService.instance.cancelAll(id);
    await NotificationService.instance.scheduleAll(entity);
    await BackgroundService.registerNaggingTask(scheduleId: id);

    return entity;
  }

  @override
  Future<void> deleteSchedule(String id) async {
    await (_db.delete(_db.scheduleTable)..where((t) => t.id.equals(id))).go();

    await NotificationService.instance.cancelAll(id);
    await BackgroundService.cancelNaggingTask(id);
  }

  @override
  Future<void> syncStatuses() async {
    final now = DateTime.now();
    final rows = await (_db.select(_db.scheduleTable)
          ..where((t) =>
              t.status.equals(ScheduleStatus.pending.name) |
              t.status.equals(ScheduleStatus.active.name) |
              t.status.equals(ScheduleStatus.snoozed.name)))
        .get();

    for (final row in rows) {
      final entity = _toEntity(row);

      if (entity.isMissed(now)) {
        await (_db.update(_db.scheduleTable)..where((t) => t.id.equals(row.id)))
            .write(ScheduleTableCompanion(
          status: const Value('missed'),
          updatedAt: Value(now),
        ));
        await NotificationService.instance.cancelAll(row.id);
      } else if (entity.status == ScheduleStatus.pending &&
          now.isAfter(entity.scheduledAt)) {
        await (_db.update(_db.scheduleTable)..where((t) => t.id.equals(row.id)))
            .write(ScheduleTableCompanion(
          status: const Value('active'),
          updatedAt: Value(now),
        ));
      }
    }
  }

  // ─────────────────────────────────────────
  // 변환 헬퍼
  // ─────────────────────────────────────────

  /// DB 행 → 도메인 엔티티 변환
  ///
  /// Args:
  ///   row: Drift가 반환한 ScheduleTableData
  /// Returns: ScheduleEntity
  ScheduleEntity _toEntity(ScheduleTableData row) {
    return ScheduleEntity(
      id: row.id,
      userId: row.userId,
      title: row.title,
      description: row.description,
      why: row.why,
      minimumAction: row.minimumAction,
      category: ScheduleCategory.values.firstWhere(
        (c) => c.name == row.category,
        orElse: () => ScheduleCategory.other,
      ),
      scheduledAt: row.scheduledAt,
      status: ScheduleStatus.values.firstWhere(
        (s) => s.name == row.status,
        orElse: () => ScheduleStatus.pending,
      ),
      naggingCount: row.naggingCount,
      snoozedUntil: row.snoozedUntil,
      completedAt: row.completedAt,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

}
