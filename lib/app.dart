import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers/repository_providers.dart';
import 'core/router/app_router.dart';

/// 루트 위젯
///
/// 역할: 앱 전체 테마·라우터 설정 + 앱 생명주기 감지.
/// 책임: appRouterProvider를 통해 GoRouter 인스턴스 수신.
///       포그라운드 복귀 시 일정 상태 재동기화.
/// 외부 의존성: appRouterProvider, scheduleRepositoryProvider
class BehaviorOSApp extends ConsumerStatefulWidget {
  const BehaviorOSApp({super.key});

  @override
  ConsumerState<BehaviorOSApp> createState() => _BehaviorOSAppState();
}

class _BehaviorOSAppState extends ConsumerState<BehaviorOSApp> {
  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(
      onResume: () {
        // 포그라운드 복귀 시 pending→active, missed 재동기화
        ref.read(scheduleRepositoryProvider).syncStatuses();
      },
    );
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Behavior OS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          onPrimary: Colors.black,
        ),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
