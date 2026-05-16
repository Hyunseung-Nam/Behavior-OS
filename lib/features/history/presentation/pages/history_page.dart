import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../schedule/domain/entities/schedule_entity.dart';
import '../../../schedule/presentation/controllers/schedule_controller.dart';
import '../../../schedule/presentation/utils/schedule_category_ui.dart';

/// 완료 일정 기록 페이지
///
/// 역할: completed 상태 일정을 날짜별로 그룹화하여 표시.
/// 책임: UI 렌더링만 담당. scheduleControllerProvider 스트림에서 completed 필터링.
class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  /// 완료 일정을 날짜(completedAt 기준)별로 그룹화
  ///
  /// Returns: 날짜 내림차순 정렬된 Map<String, List<ScheduleEntity>>
  Map<String, List<ScheduleEntity>> _groupByDate(
      List<ScheduleEntity> schedules) {
    final completed = schedules
        .where((s) =>
            s.status == ScheduleStatus.completed && s.completedAt != null)
        .toList()
      ..sort((a, b) => b.completedAt!.compareTo(a.completedAt!));

    final map = <String, List<ScheduleEntity>>{};
    for (final s in completed) {
      final key = DateFormat('yyyy년 MM월 dd일').format(s.completedAt!);
      map.putIfAbsent(key, () => []).add(s);
    }
    return map;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSchedules = ref.watch(scheduleControllerProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(
          '기록',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: asyncSchedules.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.white24),
        ),
        error: (e, _) => Center(
          child:
              Text('오류: $e', style: const TextStyle(color: Colors.white38)),
        ),
        data: (schedules) {
          final grouped = _groupByDate(schedules);

          if (grouped.isEmpty) {
            return const Center(
              child: Text(
                '완료한 일정이 없습니다.',
                style: TextStyle(color: Colors.white38, fontSize: 16),
              ),
            );
          }

          final dates = grouped.keys.toList();

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = dates[index];
              final items = grouped[date]!;
              return _DateGroup(date: date, items: items);
            },
          );
        },
      ),
    );
  }
}

/// 날짜별 그룹 위젯
///
/// 역할: 날짜 헤더 + 해당 날짜의 완료 일정 목록 표시.
class _DateGroup extends StatelessWidget {
  const _DateGroup({required this.date, required this.items});

  final String date;
  final List<ScheduleEntity> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 날짜 헤더
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Row(
            children: [
              Text(
                date,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${items.length}개 완료',
                style: const TextStyle(
                  color: Colors.white24,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const Divider(color: Colors.white10, height: 1),
        // 해당 날짜의 완료 일정들
        ...items.map((s) => _HistoryItem(schedule: s)),
      ],
    );
  }
}

/// 완료 일정 아이템 위젯
///
/// 역할: 카테고리 컬러 + 제목 + 예정 시각 + 완료 시각 + 소요 시간 표시.
class _HistoryItem extends StatelessWidget {
  const _HistoryItem({required this.schedule});

  final ScheduleEntity schedule;

  /// 예정 → 완료 소요 시간 레이블
  ///
  /// Returns: 예정보다 일찍/늦게/정각 완료 여부 문자열
  String _durationLabel() {
    final diff =
        schedule.completedAt!.difference(schedule.scheduledAt).inMinutes;
    if (diff < -1) return '${-diff}분 일찍';
    if (diff <= 5) return '정시';
    return '${diff}분 후 완료';
  }

  Color _durationColor() {
    final diff =
        schedule.completedAt!.difference(schedule.scheduledAt).inMinutes;
    if (diff <= 5) return Colors.greenAccent.withValues(alpha: 0.7);
    if (diff <= 30) return const Color(0xFFE8874A);
    return const Color(0xFFE05555);
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = schedule.category.color;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 카테고리 컬러 인디케이터
          Container(
            width: 3,
            height: 44,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),

          // 제목 + 시각 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schedule.title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '예정 ${DateFormat('HH:mm').format(schedule.scheduledAt)}  →  완료 ${DateFormat('HH:mm').format(schedule.completedAt!)}',
                  style: const TextStyle(
                    color: Colors.white24,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // 소요 시간 레이블
          Text(
            _durationLabel(),
            style: TextStyle(
              color: _durationColor(),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
