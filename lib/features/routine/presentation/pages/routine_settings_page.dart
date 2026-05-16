import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/routine_entity.dart';
import '../controllers/routine_controller.dart';

/// 루틴 설정 화면
///
/// 역할: 루틴 목록 표시 + 추가/수정/삭제/토글.
/// 책임: UI 렌더링 및 사용자 액션 → RoutineController 위임.
class RoutineSettingsPage extends ConsumerWidget {
  const RoutineSettingsPage({super.key});

  /// 루틴 추가/수정 바텀시트 호출
  ///
  /// Args:
  ///   routine: null이면 추가 모드, 값이 있으면 수정 모드
  void _openForm(BuildContext context, {RoutineEntity? routine}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF111111),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _RoutineFormSheet(routine: routine),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRoutines = ref.watch(routineControllerProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(
          '루틴',
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
            onPressed: () => _openForm(context),
            icon: const Icon(Icons.add, color: Colors.white54),
            tooltip: '루틴 추가',
          ),
        ],
      ),
      body: asyncRoutines.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.white24),
        ),
        error: (e, _) => Center(
          child: Text('오류: $e', style: const TextStyle(color: Colors.white38)),
        ),
        data: (routines) {
          if (routines.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '등록된 루틴이 없습니다.',
                    style: TextStyle(color: Colors.white38, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => _openForm(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '+ 루틴 추가',
                        style: TextStyle(color: Colors.white38, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: routines.length,
            separatorBuilder: (_, __) => const Divider(color: Colors.white10),
            itemBuilder: (context, index) {
              return _RoutineItem(
                routine: routines[index],
                onTap: () => _openForm(context, routine: routines[index]),
              );
            },
          );
        },
      ),
    );
  }
}

/// 루틴 아이템 위젯
///
/// 역할: 루틴 제목 + 알림 시각 표시 + 토글 + 스와이프 삭제.
class _RoutineItem extends ConsumerWidget {
  const _RoutineItem({required this.routine, required this.onTap});

  final RoutineEntity routine;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(routine.id),
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
              '"${routine.title}" 루틴을 삭제할까요?\n관련 알림도 취소됩니다.',
              style: const TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child:
                    const Text('취소', style: TextStyle(color: Colors.white38)),
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
        ref.read(routineControllerProvider.notifier).delete(routine.id);
      },
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              // 제목 + 알림 시각
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      routine.title,
                      style: TextStyle(
                        color:
                            routine.isEnabled ? Colors.white : Colors.white38,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '매일 ${routine.notifyTimeLabel}',
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              // 활성화 토글
              Switch(
                value: routine.isEnabled,
                activeColor: Colors.white,
                inactiveTrackColor: Colors.white12,
                onChanged: (v) {
                  ref
                      .read(routineControllerProvider.notifier)
                      .toggle(routine.id, v);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 루틴 추가/수정 바텀시트
///
/// 역할: 제목 + 알림 시각 입력 받아 루틴 생성 또는 수정.
/// Args:
///   routine: null이면 추가 모드, 값이 있으면 수정 모드
class _RoutineFormSheet extends ConsumerStatefulWidget {
  const _RoutineFormSheet({this.routine});

  final RoutineEntity? routine;

  @override
  ConsumerState<_RoutineFormSheet> createState() => _RoutineFormSheetState();
}

class _RoutineFormSheetState extends ConsumerState<_RoutineFormSheet> {
  late final TextEditingController _titleController;
  TimeOfDay _notifyTime = const TimeOfDay(hour: 9, minute: 0);
  bool _isSaving = false;

  bool get _isEditMode => widget.routine != null;

  @override
  void initState() {
    super.initState();
    final r = widget.routine;
    _titleController = TextEditingController(text: r?.title ?? '');
    if (r != null) {
      _notifyTime = TimeOfDay(hour: r.notifyHour, minute: r.notifyMinute);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _notifyTime,
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
    if (picked != null) setState(() => _notifyTime = picked);
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('제목을 입력해주세요.',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.white10,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      if (_isEditMode) {
        await ref.read(routineControllerProvider.notifier).edit(
              widget.routine!.id,
              title: title,
              notifyHour: _notifyTime.hour,
              notifyMinute: _notifyTime.minute,
            );
      } else {
        await ref.read(routineControllerProvider.notifier).add(
              title: title,
              notifyHour: _notifyTime.hour,
              notifyMinute: _notifyTime.minute,
            );
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('저장 실패: $e',
                style: const TextStyle(color: Colors.white)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final timeLabel =
        '${_notifyTime.hour.toString().padLeft(2, '0')}:${_notifyTime.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isEditMode ? '루틴 수정' : '새 루틴',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white38),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 제목 입력
          TextField(
            controller: _titleController,
            autofocus: true,
            style: const TextStyle(color: Colors.white, fontSize: 18),
            decoration: const InputDecoration(
              hintText: '어떤 루틴인가요?',
              hintStyle: TextStyle(color: Colors.white38),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white24),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 알림 시각 선택
          GestureDetector(
            onTap: _pickTime,
            child: Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time,
                      color: Colors.white54, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    '매일 $timeLabel 알림',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // 저장 버튼
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                disabledBackgroundColor: Colors.white24,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : Text(
                      _isEditMode ? '수정' : '추가',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
