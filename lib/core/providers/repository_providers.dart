import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/database/app_database.dart';
import '../../features/schedule/data/repositories/schedule_repository_impl.dart';
import '../../features/schedule/domain/repositories/schedule_repository.dart';
import '../../features/routine/data/repositories/routine_repository_impl.dart';
import '../../features/routine/domain/repositories/routine_repository.dart';

/// AppDatabase 전역 Provider
///
/// 싱글턴으로 관리 — DB 파일이 앱 전체에서 1개만 열려야 함.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// ScheduleRepository 전역 Provider
///
/// 싱글턴으로 관리 — 스트림이 앱 전체에서 공유되어야 함.
final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ScheduleRepositoryImpl(db);
});

/// RoutineRepository 전역 Provider
///
/// 싱글턴으로 관리 — 스트림이 앱 전체에서 공유되어야 함.
final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return RoutineRepositoryImpl(db);
});
