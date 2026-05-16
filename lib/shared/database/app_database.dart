import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// 일정 테이블 정의
///
/// 역할: Drift ORM 스키마 선언. ScheduleEntity 필드와 1:1 대응.
/// 기본키: id (UUID 문자열)
class ScheduleTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get why => text().nullable()();
  TextColumn get minimumAction => text().nullable()();
  TextColumn get category =>
      text().withDefault(const Constant('other'))();
  DateTimeColumn get scheduledAt => dateTime()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  IntColumn get naggingCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get snoozedUntil => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get calendarEventId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 루틴 테이블 정의
///
/// 역할: 매일 반복 알림을 가지는 루틴 항목 저장.
/// 기본키: id (UUID 문자열)
class RoutineTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  IntColumn get notifyHour => integer()();
  IntColumn get notifyMinute => integer()();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 앱 로컬 데이터베이스
///
/// 역할: Drift 기반 SQLite 싱글턴. 앱 전역에서 공유.
/// 책임: 테이블 관리, 마이그레이션 버전 관리.
/// 외부 의존성: drift_flutter, path_provider
@DriftDatabase(tables: [ScheduleTable, RoutineTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(scheduleTable, scheduleTable.why);
        await migrator.addColumn(scheduleTable, scheduleTable.minimumAction);
        await migrator.addColumn(scheduleTable, scheduleTable.category);
      }
      if (from < 3) {
        await migrator.addColumn(
            scheduleTable, scheduleTable.calendarEventId);
      }
      if (from < 4) {
        await migrator.createTable(routineTable);
      }
    },
  );

  /// 데이터베이스 파일 경로 설정
  ///
  /// Returns: QueryExecutor — drift_flutter가 플랫폼별 경로 자동 처리
  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'behavior_os');
  }
}
