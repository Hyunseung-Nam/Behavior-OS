// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todayCompletedCountHash() =>
    r'adc48c3ff40c5e05c4ac91a422461a0f8155b9df';

/// 오늘 완료한 일정 개수 스트림
///
/// Copied from [todayCompletedCount].
@ProviderFor(todayCompletedCount)
final todayCompletedCountProvider = AutoDisposeStreamProvider<int>.internal(
  todayCompletedCount,
  name: r'todayCompletedCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todayCompletedCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayCompletedCountRef = AutoDisposeStreamProviderRef<int>;
String _$focusControllerHash() => r'e1c6ae5b57807c9fdda4b0455f5ef41e1db77f7e';

/// Focus 화면 컨트롤러
///
/// 역할: 현재 액션이 필요한 단 1개의 일정만 노출.
/// 우선순위: active(Nagging 중) > snoozed(연기 만료) > 다음 pending
/// 책임: 완료 / 연기 처리, syncStatuses() 호출 (상태 동기화)
///
/// Copied from [FocusController].
@ProviderFor(FocusController)
final focusControllerProvider = AutoDisposeStreamNotifierProvider<
    FocusController, ScheduleEntity?>.internal(
  FocusController.new,
  name: r'focusControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$focusControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FocusController = AutoDisposeStreamNotifier<ScheduleEntity?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
