import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/schedule_entity.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../../../../shared/services/notification_service.dart';
import '../../../../shared/services/background_service.dart';

/// 일정 Repository 구현체 (로컬 우선)
///
/// 역할: SharedPreferences 기반 로컬 저장소 + 알림 서비스 연동.
/// 책임:
///   - 일정 CRUD
///   - 생성 시 NotificationService.scheduleAll() 호출
///   - 완료/연기 시 알림 취소 및 재스케줄
///   - Workmanager Nagging 작업 등록/취소
/// 외부 의존성: SharedPreferences, NotificationService, BackgroundService
///
/// 참고: 추후 Drift(SQLite) + Supabase로 교체 예정. 인터페이스는 동일.
class ScheduleRepositoryImpl implements ScheduleRepository {
  static const _storageKey = 'schedules';
  final _uuid = const Uuid();

  // 인메모리 스트림 컨트롤러 (SharedPreferences 변경 시 broadcast)
  final _controller =
      StreamController<List<ScheduleEntity>>.broadcast();

  ScheduleRepositoryImpl() {
    _loadAndBroadcast();
  }

  @override
  Stream<List<ScheduleEntity>> watchSchedules() => _controller.stream;

  @override
  Future<ScheduleEntity?> getSchedule(String id) async {
    final all = await _loadAll();
    try {
      return all.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<ScheduleEntity> createSchedule({
    required String title,
    String? description,
    required DateTime scheduledAt,
  }) async {
    final now = DateTime.now();
    final schedule = ScheduleEntity(
      id: _uuid.v4(),
      userId: 'local',
      title: title,
      description: description,
      scheduledAt: scheduledAt,
      status: ScheduleStatus.pending,
      createdAt: now,
      updatedAt: now,
    );

    final all = await _loadAll();
    all.add(schedule);
    await _saveAll(all);

    // 다단계 알림 + Nagging 스케줄링
    await NotificationService.instance.scheduleAll(schedule);

    // 60분 후 Workmanager 백그라운드 체크 등록
    await BackgroundService.registerNaggingTask(scheduleId: schedule.id);

    _broadcast(all);
    return schedule;
  }

  @override
  Future<void> completeSchedule(String id) async {
    final all = await _loadAll();
    final idx = all.indexWhere((s) => s.id == id);
    if (idx == -1) return;

    all[idx] = all[idx].copyWith(
      status: ScheduleStatus.completed,
      completedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await _saveAll(all);

    // 모든 알림 취소
    await NotificationService.instance.cancelAll(id);
    await BackgroundService.cancelNaggingTask(id);

    _broadcast(all);
  }

  @override
  Future<void> snoozeSchedule(String id) async {
    final all = await _loadAll();
    final idx = all.indexWhere((s) => s.id == id);
    if (idx == -1) return;

    final snoozedUntil = DateTime.now().add(const Duration(minutes: 10));
    all[idx] = all[idx].copyWith(
      status: ScheduleStatus.snoozed,
      snoozedUntil: snoozedUntil,
      updatedAt: DateTime.now(),
    );
    await _saveAll(all);

    // Nagging 취소 + 10분 후 재트리거 등록
    await NotificationService.instance.cancelNagging(id);
    await NotificationService.instance.scheduleSnoozeReminder(
      scheduleId: id,
      title: all[idx].title,
    );

    _broadcast(all);
  }

  @override
  Future<List<ScheduleEntity>> getMissedSchedules() async {
    final all = await _loadAll();
    return all.where((s) => s.status == ScheduleStatus.missed).toList();
  }

  @override
  Future<ScheduleEntity> rescheduleSchedule(
      String id, DateTime newScheduledAt) async {
    final all = await _loadAll();
    final idx = all.indexWhere((s) => s.id == id);
    if (idx == -1) throw Exception('일정을 찾을 수 없습니다: $id');

    all[idx] = all[idx].copyWith(
      scheduledAt: newScheduledAt,
      status: ScheduleStatus.pending,
      naggingCount: 0,
      snoozedUntil: null,
      updatedAt: DateTime.now(),
    );
    await _saveAll(all);

    // 새 시간으로 알림 재등록
    await NotificationService.instance.cancelAll(id);
    await NotificationService.instance.scheduleAll(all[idx]);
    await BackgroundService.registerNaggingTask(scheduleId: id);

    _broadcast(all);
    return all[idx];
  }

  @override
  Future<void> deleteSchedule(String id) async {
    final all = await _loadAll();
    all.removeWhere((s) => s.id == id);
    await _saveAll(all);

    await NotificationService.instance.cancelAll(id);
    await BackgroundService.cancelNaggingTask(id);

    _broadcast(all);
  }

  // ─────────────────────────────────────────
  // Private helpers
  // ─────────────────────────────────────────

  Future<List<ScheduleEntity>> _loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_storageKey) ?? [];
    return raw
        .map((e) => _fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveAll(List<ScheduleEntity> schedules) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _storageKey,
      schedules.map((s) => jsonEncode(_toJson(s))).toList(),
    );
  }

  void _broadcast(List<ScheduleEntity> schedules) {
    _controller.add(schedules);
  }

  Future<void> _loadAndBroadcast() async {
    final all = await _loadAll();
    _broadcast(all);
  }

  Map<String, dynamic> _toJson(ScheduleEntity s) => {
        'id': s.id,
        'userId': s.userId,
        'title': s.title,
        'description': s.description,
        'scheduledAt': s.scheduledAt.toIso8601String(),
        'status': s.status.name,
        'naggingCount': s.naggingCount,
        'snoozedUntil': s.snoozedUntil?.toIso8601String(),
        'completedAt': s.completedAt?.toIso8601String(),
        'createdAt': s.createdAt.toIso8601String(),
        'updatedAt': s.updatedAt.toIso8601String(),
      };

  ScheduleEntity _fromJson(Map<String, dynamic> j) => ScheduleEntity(
        id: j['id'] as String,
        userId: j['userId'] as String,
        title: j['title'] as String,
        description: j['description'] as String?,
        scheduledAt: DateTime.parse(j['scheduledAt'] as String),
        status: ScheduleStatus.values.firstWhere(
          (s) => s.name == j['status'],
          orElse: () => ScheduleStatus.pending,
        ),
        naggingCount: j['naggingCount'] as int,
        snoozedUntil: j['snoozedUntil'] != null
            ? DateTime.parse(j['snoozedUntil'] as String)
            : null,
        completedAt: j['completedAt'] != null
            ? DateTime.parse(j['completedAt'] as String)
            : null,
        createdAt: DateTime.parse(j['createdAt'] as String),
        updatedAt: DateTime.parse(j['updatedAt'] as String),
      );
}

