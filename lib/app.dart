import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';

/// 루트 위젯
///
/// 역할: 앱 전체 테마·라우터 설정.
/// 책임: appRouterProvider를 통해 GoRouter 인스턴스 수신.
/// 외부 의존성: appRouterProvider (인증 상태에 따라 자동 리다이렉트 포함)
class BehaviorOSApp extends ConsumerWidget {
  const BehaviorOSApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
