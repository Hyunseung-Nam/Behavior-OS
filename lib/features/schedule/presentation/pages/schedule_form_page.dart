import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/schedule_entity.dart';
import '../controllers/schedule_controller.dart';
import '../utils/schedule_category_ui.dart';

/// 일정 등록/수정 바텀시트
///
/// 역할: 제목 + 날짜/시간 + why + minimumAction + category 입력 받아 일정 생성 또는 수정.
/// 책임: 입력 유효성 검사 + ScheduleController.create() / update() 호출.
/// Args:
///   schedule: null이면 등록 모드, 값이 있으면 수정 모드
class ScheduleFormPage extends ConsumerStatefulWidget {
  const ScheduleFormPage({super.key, this.schedule});

  final ScheduleEntity? schedule;

  @override
  ConsumerState<ScheduleFormPage> createState() => _ScheduleFormPageState();
}

class _ScheduleFormPageState extends ConsumerState<ScheduleFormPage> {
  final _titleController = TextEditingController();
  final _whyController = TextEditingController();
  final _minActionController = TextEditingController();
  DateTime? _selectedDateTime;
  ScheduleCategory _category = ScheduleCategory.other;
  bool _isSaving = false;

  bool get _isEditMode => widget.schedule != null;

  @override
  void initState() {
    super.initState();
    final s = widget.schedule;
    if (s != null) {
      _titleController.text = s.title;
      _whyController.text = s.why ?? '';
      _minActionController.text = s.minimumAction ?? '';
      _selectedDateTime = s.scheduledAt;
      _category = s.category;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _whyController.dispose();
    _minActionController.dispose();
    super.dispose();
  }

  /// 날짜 + 시간 선택 다이얼로그 순차 호출
  Future<void> _pickDateTime() async {
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
    if (date == null || !mounted) return;

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
    if (time == null || !mounted) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year, date.month, date.day, time.hour, time.minute,
      );
    });
  }

  /// 저장 버튼 처리
  ///
  /// Side Effects: ScheduleController.create() 호출, 바텀시트 닫기
  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목을 입력해주세요.')),
      );
      return;
    }
    if (_selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('날짜와 시간을 선택해주세요.')),
      );
      return;
    }

    final why = _whyController.text.trim().isEmpty
        ? null
        : _whyController.text.trim();
    final minimumAction = _minActionController.text.trim().isEmpty
        ? null
        : _minActionController.text.trim();

    setState(() => _isSaving = true);
    try {
      if (_isEditMode) {
        await ref.read(scheduleControllerProvider.notifier).edit(
              id: widget.schedule!.id,
              title: title,
              why: why,
              minimumAction: minimumAction,
              category: _category,
              scheduledAt: _selectedDateTime!,
            );
      } else {
        await ref.read(scheduleControllerProvider.notifier).create(
              title: title,
              why: why,
              minimumAction: minimumAction,
              category: _category,
              scheduledAt: _selectedDateTime!,
            );
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 실패: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final accentColor = _category.color;

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
                _isEditMode ? '일정 수정' : '새 일정',
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

          // 카테고리 선택
          _CategorySelector(
            selected: _category,
            onChanged: (c) => setState(() => _category = c),
          ),
          const SizedBox(height: 20),

          // 제목 입력
          TextField(
            controller: _titleController,
            autofocus: true,
            style: const TextStyle(color: Colors.white, fontSize: 18),
            decoration: InputDecoration(
              hintText: '무엇을 해야 하나요?',
              hintStyle: const TextStyle(color: Colors.white38),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white24),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: accentColor),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 왜 중요한가 (선택)
          TextField(
            controller: _whyController,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
            decoration: const InputDecoration(
              hintText: '왜 중요한가요? (선택)',
              hintStyle: TextStyle(color: Colors.white24),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white12),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white38),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 최소 행동 (선택)
          TextField(
            controller: _minActionController,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
            decoration: const InputDecoration(
              hintText: '최소한 이것만 하면 됩니다. (선택)',
              hintStyle: TextStyle(color: Colors.white24),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white12),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white38),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 날짜/시간 선택
          GestureDetector(
            onTap: _pickDateTime,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _selectedDateTime != null
                      ? accentColor.withValues(alpha: 0.6)
                      : Colors.white24,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.schedule,
                    color: _selectedDateTime != null
                        ? accentColor
                        : Colors.white38,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _selectedDateTime == null
                        ? '날짜 / 시간 선택'
                        : DateFormat('MM월 dd일 HH:mm').format(_selectedDateTime!),
                    style: TextStyle(
                      color: _selectedDateTime == null
                          ? Colors.white38
                          : Colors.white,
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
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
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
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      _isEditMode ? '수정' : '등록',
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

/// 카테고리 선택 칩 행
class _CategorySelector extends StatelessWidget {
  const _CategorySelector({
    required this.selected,
    required this.onChanged,
  });

  final ScheduleCategory selected;
  final ValueChanged<ScheduleCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ScheduleCategory.values.map((category) {
          final isSelected = category == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onChanged(category),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected
                      ? category.color.withValues(alpha: 0.2)
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? category.color : Colors.white24,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  category.label,
                  style: TextStyle(
                    color: isSelected ? category.color : Colors.white38,
                    fontSize: 13,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
