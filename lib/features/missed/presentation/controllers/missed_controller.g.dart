// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'missed_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$missedControllerHash() => r'5bb6524956a8fbfe92251f3de885419408bd8e3c';

/// 놓친 일정 컨트롤러
///
/// 역할: missed 상태 일정 스트림 노출 + 재스케줄링/삭제 처리.
/// 책임: UI 흐름 제어만 담당. 비즈니스 로직은 Repository에 위임.
/// 외부 의존성: ScheduleRepository (scheduleRepositoryProvider)
///
/// Copied from [MissedController].
@ProviderFor(MissedController)
final missedControllerProvider = AutoDisposeStreamNotifierProvider<
    MissedController, List<ScheduleEntity>>.internal(
  MissedController.new,
  name: r'missedControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$missedControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MissedController = AutoDisposeStreamNotifier<List<ScheduleEntity>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
