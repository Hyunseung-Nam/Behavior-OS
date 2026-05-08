// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appRouterHash() => r'84c45b43d53d3581ea69e2200320076627cc71a2';

/// 라우터 설정
///
/// 역할: 알림 탭 시 딥링크로 Focus 화면 직행 지원.
/// 경로:
///   /          → FocusPage (메인, 지금 해야 할 단 1개)
///   /schedule  → 일정 목록/등록
///   /missed    → 놓친 일정 보관함
///   /focus/:id → 알림 딥링크 (FocusPage)
///
/// Copied from [appRouter].
@ProviderFor(appRouter)
final appRouterProvider = AutoDisposeProvider<GoRouter>.internal(
  appRouter,
  name: r'appRouterProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appRouterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppRouterRef = AutoDisposeProviderRef<GoRouter>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
