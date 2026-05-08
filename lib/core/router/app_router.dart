import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/focus/presentation/pages/focus_page.dart';
import '../../features/missed/presentation/pages/missed_page.dart';
import '../../features/schedule/presentation/pages/schedule_list_page.dart';

part 'app_router.g.dart';

/// 라우터 설정
///
/// 역할: 알림 탭 시 딥링크로 Focus 화면 직행 지원.
/// 경로:
///   /          → FocusPage (메인, 지금 해야 할 단 1개)
///   /schedule  → 일정 목록/등록
///   /missed    → 놓친 일정 보관함
///   /focus/:id → 알림 딥링크 (FocusPage)
@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const FocusPage(),
      ),
      GoRoute(
        path: '/schedule',
        builder: (context, state) => const ScheduleListPage(),
      ),
      GoRoute(
        path: '/missed',
        builder: (context, state) => const MissedPage(),
      ),
      // 알림 탭 시 딥링크: /focus/:id
      GoRoute(
        path: '/focus/:id',
        builder: (context, state) => const FocusPage(),
      ),
    ],
  );
}
