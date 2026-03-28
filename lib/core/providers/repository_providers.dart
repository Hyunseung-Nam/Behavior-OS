import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/schedule/data/repositories/schedule_repository_impl.dart';
import '../../features/schedule/domain/repositories/schedule_repository.dart';

/// ScheduleRepository 전역 Provider
///
/// 싱글톤으로 관리 — 스트림이 앱 전체에서 공유되어야 함.
final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  return ScheduleRepositoryImpl();
});
