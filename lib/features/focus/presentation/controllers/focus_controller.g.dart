// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$focusControllerHash() => r'759dee32456a8633fc795b183284253ecc7664dc';

/// Focus 화면 컨트롤러
///
/// 역할: 현재 액션이 필요한 단 1개의 일정만 노출.
/// 우선순위: active(Nagging 중) > snoozed(연기 만료) > 다음 pending
/// 책임: 완료 / 연기 처리만 담당 (비즈니스 로직은 Repository에 위임)
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
