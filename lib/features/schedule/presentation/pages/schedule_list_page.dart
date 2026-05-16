import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/schedule_entity.dart';
import '../controllers/schedule_controller.dart';
import 'schedule_form_page.dart';

/// 일정 목록 페이지
///
/// 역할: pending/active/snoozed 상태의 일정 목록 표시 + 삭제 + 등록 진입.
/// 책임: UI 렌더링 및 사용자 액션 → ScheduleController 위임.
/// 외부 의존성: ScheduleController
class ScheduleListPage extends ConsumerWidget {
  const ScheduleListPage({super.key});

  /// 일정 등록/수정 바텀시트 호출
  ///
  /// Args:
  ///   schedule: null이면 등록 모드, 값이 있으면 수정 모드
  void _openForm(BuildContext context, {ScheduleEntity? schedule}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF111111),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ScheduleFormPage(schedule: schedule),
    );
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
          '일정',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => context.push('/settings/routines'),
            icon: const Icon(Icons.repeat, color: Colors.white38),
            tooltip: '루틴 설정',
          ),
          IconButton(
            onPressed: () => context.push('/history'),
            icon: const Icon(Icons.history, color: Colors.white38),
            tooltip: '기록',
          ),
          IconButton(
            onPressed: () => context.push('/missed'),
            icon: const Icon(Icons.inbox_outlined, color: Colors.white38),
            tooltip: '놓친 일정',
          ),
        ],
      ),
      body: asyncSchedules.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.white24),
        ),
        error: (e, _) => Center(
          child: Text('오류: $e', style: const TextStyle(color: Colors.white38)),
        ),
        data: (schedules) {
          // 완료/놓침 제외한 활성 일정만 표시
          final active = schedules
              .where((s) =>
                  s.status != ScheduleStatus.completed &&
                  s.status != ScheduleStatus.missed)
              .toList()
            ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

          if (active.isEmpty) {
            return const Center(
              child: Text(
                '등록된 일정이 없습니다.',
                style: TextStyle(color: Colors.white38, fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: active.length,
            separatorBuilder: (_, __) => const Divider(color: Colors.white10),
            itemBuilder: (context, index) {
              final schedule = active[index];
              return _ScheduleItem(
                schedule: schedule,
                onTap: () => _openForm(context, schedule: schedule),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(context),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// 개별 일정 아이템 위젯
///
/// 역할: 일정 제목, 시간, 상태 배지 표시 + 탭 수정 + 스와이프 삭제.
class _ScheduleItem extends ConsumerWidget {
  const _ScheduleItem({required this.schedule, required this.onTap});

  final ScheduleEntity schedule;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(schedule.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: Colors.red),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: const Color(0xFF1A1A1A),
            title: const Text('삭제', style: TextStyle(color: Colors.white)),
            content: Text(
              '"${schedule.title}" 일정을 삭제할까요?\n관련 알림도 모두 취소됩니다.',
              style: const TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('취소', style: TextStyle(color: Colors.white38)),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('삭제', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        ref.read(scheduleControllerProvider.notifier).delete(schedule.id);
      },
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // 상태 인디케이터
            Container(
              width: 4,
              height: 48,
              decoration: BoxDecoration(
                color: _statusColor(schedule.status),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),

            // 제목 + 시간
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    schedule.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MM월 dd일 HH:mm').format(schedule.scheduledAt),
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // 상태 배지
            _StatusBadge(status: schedule.status),
          ],
        ),
      ),
      ),
    );
  }

  Color _statusColor(ScheduleStatus status) {
    return switch (status) {
      ScheduleStatus.active => Colors.white,
      ScheduleStatus.snoozed => Colors.orange,
      ScheduleStatus.pending => Colors.white24,
      _ => Colors.transparent,
    };
  }
}

/// 상태 배지 위젯
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final ScheduleStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      ScheduleStatus.active => ('진행중', Colors.white),
      ScheduleStatus.snoozed => ('연기됨', Colors.orange),
      ScheduleStatus.pending => ('대기', Colors.white24),
      _ => ('', Colors.transparent),
    };

    if (label.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12),
      ),
    );
  }
}
