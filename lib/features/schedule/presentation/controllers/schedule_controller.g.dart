// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$scheduleControllerHash() =>
    r'03a8f58d08f28f83364075b219a9008af3d73ca0';

/// 일정 목록 컨트롤러
///
/// 역할: 전체 일정 스트림 노출 + 삭제 처리.
/// 책임: UI에 데이터 제공, 흐름 제어만 담당. 비즈니스 로직은 Repository에 위임.
/// 외부 의존성: ScheduleRepository (scheduleRepositoryProvider)
///
/// Copied from [ScheduleController].
@ProviderFor(ScheduleController)
final scheduleControllerProvider = AutoDisposeStreamNotifierProvider<
    ScheduleController, List<ScheduleEntity>>.internal(
  ScheduleController.new,
  name: r'scheduleControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$scheduleControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ScheduleController = AutoDisposeStreamNotifier<List<ScheduleEntity>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
