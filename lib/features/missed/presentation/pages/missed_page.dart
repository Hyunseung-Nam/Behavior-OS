import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../schedule/domain/entities/schedule_entity.dart';
import '../controllers/missed_controller.dart';

/// 놓친 일정 보관함 페이지
///
/// 역할: missed 상태 일정 목록 표시 + 재스케줄링/삭제.
/// 책임: UI 렌더링 및 사용자 액션 → MissedController 위임.
/// 외부 의존성: MissedController
class MissedPage extends ConsumerWidget {
  const MissedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMissed = ref.watch(missedControllerProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(
          '놓친 일정',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: asyncMissed.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.white24),
        ),
        error: (e, _) => Center(
          child: Text('오류: $e', style: const TextStyle(color: Colors.white38)),
        ),
        data: (missed) {
          if (missed.isEmpty) {
            return const Center(
              child: Text(
                '놓친 일정이 없습니다.',
                style: TextStyle(color: Colors.white38, fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: missed.length,
            separatorBuilder: (_, __) => const Divider(color: Colors.white10),
            itemBuilder: (context, index) {
              return _MissedItem(schedule: missed[index]);
            },
          );
        },
      ),
    );
  }
}

/// 놓친 일정 아이템 위젯
///
/// 역할: 일정 정보 표시 + 재스케줄링/삭제 액션 제공.
class _MissedItem extends ConsumerWidget {
  const _MissedItem({required this.schedule});

  final ScheduleEntity schedule;

  /// 재스케줄링 날짜/시간 선택 후 처리
  ///
  /// Side Effects: MissedController.reschedule() 호출
  Future<void> _reschedule(BuildContext context, WidgetRef ref) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(hours: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Colors.white,
            onPrimary: Colors.black,
            surface: Color(0xFF1A1A1A),
            onSurface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (date == null || !context.mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Colors.white,
            onPrimary: Colors.black,
            surface: Color(0xFF1A1A1A),
            onSurface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (time == null || !context.mounted) return;

    final newTime = DateTime(
      date.year, date.month, date.day, time.hour, time.minute,
    );

    try {
      await ref
          .read(missedControllerProvider.notifier)
          .reschedule(schedule.id, newTime);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '일정이 재등록되었습니다.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.white10,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('재스케줄 실패: $e')),
        );
      }
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('삭제', style: TextStyle(color: Colors.white)),
        content: Text(
          '"${schedule.title}" 일정을 삭제할까요?',
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

    if (confirmed == true) {
      await ref.read(missedControllerProvider.notifier).delete(schedule.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // 좌측 빨간 인디케이터
          Container(
            width: 4,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.6),
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
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${DateFormat('MM월 dd일 HH:mm').format(schedule.scheduledAt)} 예정이었음',
                  style: const TextStyle(
                    color: Colors.white24,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // 액션 버튼
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 재스케줄링
              IconButton(
                onPressed: () => _reschedule(context, ref),
                icon: const Icon(Icons.replay, color: Colors.white38, size: 20),
                tooltip: '재스케줄',
              ),
              // 삭제
              IconButton(
                onPressed: () => _confirmDelete(context, ref),
                icon: const Icon(Icons.delete_outline,
                    color: Colors.red, size: 20),
                tooltip: '삭제',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
