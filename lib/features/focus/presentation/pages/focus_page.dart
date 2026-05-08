import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../controllers/focus_controller.dart';
import '../../../schedule/domain/entities/schedule_entity.dart';
import '../../../schedule/presentation/utils/schedule_category_ui.dart';

/// Focus UI 페이지 — 지금 당장 해야 할 단 1개의 행동만 표시
///
/// 역할: FocusController 스트림을 구독해 가장 시급한 일정을 전체 화면으로 표시.
/// 상태별 UI:
///   - loading: 로딩 인디케이터
///   - null (없음): 대기 화면
///   - ScheduleEntity: 카테고리 컬러 + why + minimumAction + 경과 시간 + 버튼
class FocusPage extends ConsumerWidget {
  const FocusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSchedule = ref.watch(focusControllerProvider);

    return asyncSchedule.when(
      loading: () => const _LoadingScreen(),
      error: (e, _) => _ErrorScreen(error: e),
      data: (schedule) => schedule == null
          ? const _IdleScreen()
          : _ActiveScreen(schedule: schedule),
    );
  }
}

// ─────────────────────────────────────────
// 로딩 화면
// ─────────────────────────────────────────

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.white24,
          strokeWidth: 1.5,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// 에러 화면
// ─────────────────────────────────────────

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({required this.error});
  final Object error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          '오류가 발생했습니다.',
          style: const TextStyle(color: Colors.white38),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// 대기 화면 (할 일 없음)
// ─────────────────────────────────────────

class _IdleScreen extends ConsumerWidget {
  const _IdleScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedCount = ref.watch(todayCompletedCountProvider).valueOrNull ?? 0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _TopBar(onScheduleTap: () => context.push('/schedule')),
              Column(
                children: [
                  const Text(
                    '지금 당장 할 일이 없습니다.',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 18,
                    ),
                  ),
                  if (completedCount > 0) ...[
                    const SizedBox(height: 16),
                    Text(
                      '오늘 $completedCount개 완료',
                      style: const TextStyle(
                        color: Colors.white24,
                        fontSize: 13,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: () => context.push('/schedule'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text(
                        '+ 일정 등록',
                        style: TextStyle(color: Colors.white38, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// 활성 화면 (할 일 있음)
// ─────────────────────────────────────────

class _ActiveScreen extends ConsumerStatefulWidget {
  const _ActiveScreen({required this.schedule});
  final ScheduleEntity schedule;

  @override
  ConsumerState<_ActiveScreen> createState() => _ActiveScreenState();
}

class _ActiveScreenState extends ConsumerState<_ActiveScreen>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();

    _elapsed = DateTime.now().difference(widget.schedule.scheduledAt);

    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) {
        setState(() {
          _elapsed = DateTime.now().difference(widget.schedule.scheduledAt);
        });
      }
    });

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _timer.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  String get _elapsedLabel {
    final diff = DateTime.now().difference(widget.schedule.scheduledAt).inMinutes;
    if (diff <= -1) return '${-diff}분 후 시작';
    if (diff == 0) return '지금';
    return '${diff}분 경과';
  }

  @override
  Widget build(BuildContext context) {
    final schedule = widget.schedule;
    final accentColor = schedule.category.color;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 상단 바
                _TopBar(
                  accentColor: accentColor,
                  onScheduleTap: () => context.push('/schedule'),
                ),

                // 중앙 콘텐츠
                _ContentArea(
                  schedule: schedule,
                  accentColor: accentColor,
                  elapsedLabel: _elapsedLabel,
                  elapsed: _elapsed,
                ),

                // 하단 버튼
                _ActionButtons(
                  schedule: schedule,
                  accentColor: accentColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// 공통 상단 바
// ─────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar({this.accentColor, required this.onScheduleTap});

  final Color? accentColor;
  final VoidCallback onScheduleTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'BEHAVIOR OS',
          style: TextStyle(
            color: accentColor?.withValues(alpha: 0.4) ?? Colors.white24,
            fontSize: 13,
            letterSpacing: 4,
            fontWeight: FontWeight.w500,
          ),
        ),
        GestureDetector(
          onTap: onScheduleTap,
          child: Icon(
            Icons.list,
            color: accentColor?.withValues(alpha: 0.4) ?? Colors.white24,
            size: 22,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
// 중앙 콘텐츠 영역
// ─────────────────────────────────────────

class _ContentArea extends StatelessWidget {
  const _ContentArea({
    required this.schedule,
    required this.accentColor,
    required this.elapsedLabel,
    required this.elapsed,
  });

  final ScheduleEntity schedule;
  final Color accentColor;
  final String elapsedLabel;
  final Duration elapsed;

  /// 경과/남은 시간에 따른 색상
  ///   30분 전~정각 → 카테고리 accent (예고)
  ///   1~10분 경과  → 카테고리 accent
  ///   11~30분 경과 → 주황
  ///   30분 초과    → 빨간색
  Color _elapsedColor(Duration elapsed, Color accentColor) {
    final m = elapsed.inMinutes;
    if (m < 0) return accentColor;
    if (m <= 10) return accentColor;
    if (m <= 30) return const Color(0xFFE8874A);
    return const Color(0xFFE05555);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 경과 시간 레이블
        Text(
          elapsedLabel,
          style: TextStyle(
            color: _elapsedColor(elapsed, accentColor),
            fontSize: 13,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 20),

        // 제목
        Text(
          schedule.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
        ),

        // why — 본인이 쓴 이유
        if (schedule.why != null && schedule.why!.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            schedule.why!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ],

        // minimum action
        if (schedule.minimumAction != null &&
            schedule.minimumAction!.isNotEmpty) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: accentColor.withValues(alpha: 0.4)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              schedule.minimumAction!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: accentColor,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────
// 완료 / 연기 버튼
// ─────────────────────────────────────────

class _ActionButtons extends ConsumerWidget {
  const _ActionButtons({
    required this.schedule,
    required this.accentColor,
  });

  final ScheduleEntity schedule;
  final Color accentColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(focusControllerProvider.notifier);

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 64,
          child: ElevatedButton(
            onPressed: () async {
              await controller.complete(schedule.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              '행동 완료',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: () async {
              await controller.snooze(schedule.id);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white54,
              side: BorderSide(color: accentColor.withValues(alpha: 0.3)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              '10분 연기',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
