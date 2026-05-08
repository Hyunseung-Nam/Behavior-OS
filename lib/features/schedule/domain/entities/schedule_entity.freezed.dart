// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ScheduleEntity {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// 이게 왜 중요한가 (선택 입력, FocusPage + 알림에 표시)
  String? get why => throw _privateConstructorUsedError;

  /// 최소한 이것만 (선택 입력, FocusPage에서 시작 마찰 감소)
  String? get minimumAction => throw _privateConstructorUsedError;

  /// 카테고리 (FocusPage 포인트 컬러 결정)
  ScheduleCategory get category => throw _privateConstructorUsedError;
  DateTime get scheduledAt => throw _privateConstructorUsedError;
  ScheduleStatus get status => throw _privateConstructorUsedError;
  int get naggingCount => throw _privateConstructorUsedError;
  DateTime? get snoozedUntil => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of ScheduleEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScheduleEntityCopyWith<ScheduleEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleEntityCopyWith<$Res> {
  factory $ScheduleEntityCopyWith(
          ScheduleEntity value, $Res Function(ScheduleEntity) then) =
      _$ScheduleEntityCopyWithImpl<$Res, ScheduleEntity>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String title,
      String? description,
      String? why,
      String? minimumAction,
      ScheduleCategory category,
      DateTime scheduledAt,
      ScheduleStatus status,
      int naggingCount,
      DateTime? snoozedUntil,
      DateTime? completedAt,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$ScheduleEntityCopyWithImpl<$Res, $Val extends ScheduleEntity>
    implements $ScheduleEntityCopyWith<$Res> {
  _$ScheduleEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScheduleEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? description = freezed,
    Object? why = freezed,
    Object? minimumAction = freezed,
    Object? category = null,
    Object? scheduledAt = null,
    Object? status = null,
    Object? naggingCount = null,
    Object? snoozedUntil = freezed,
    Object? completedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      why: freezed == why
          ? _value.why
          : why // ignore: cast_nullable_to_non_nullable
              as String?,
      minimumAction: freezed == minimumAction
          ? _value.minimumAction
          : minimumAction // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ScheduleCategory,
      scheduledAt: null == scheduledAt
          ? _value.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ScheduleStatus,
      naggingCount: null == naggingCount
          ? _value.naggingCount
          : naggingCount // ignore: cast_nullable_to_non_nullable
              as int,
      snoozedUntil: freezed == snoozedUntil
          ? _value.snoozedUntil
          : snoozedUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScheduleEntityImplCopyWith<$Res>
    implements $ScheduleEntityCopyWith<$Res> {
  factory _$$ScheduleEntityImplCopyWith(_$ScheduleEntityImpl value,
          $Res Function(_$ScheduleEntityImpl) then) =
      __$$ScheduleEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String title,
      String? description,
      String? why,
      String? minimumAction,
      ScheduleCategory category,
      DateTime scheduledAt,
      ScheduleStatus status,
      int naggingCount,
      DateTime? snoozedUntil,
      DateTime? completedAt,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$ScheduleEntityImplCopyWithImpl<$Res>
    extends _$ScheduleEntityCopyWithImpl<$Res, _$ScheduleEntityImpl>
    implements _$$ScheduleEntityImplCopyWith<$Res> {
  __$$ScheduleEntityImplCopyWithImpl(
      _$ScheduleEntityImpl _value, $Res Function(_$ScheduleEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScheduleEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? description = freezed,
    Object? why = freezed,
    Object? minimumAction = freezed,
    Object? category = null,
    Object? scheduledAt = null,
    Object? status = null,
    Object? naggingCount = null,
    Object? snoozedUntil = freezed,
    Object? completedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ScheduleEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      why: freezed == why
          ? _value.why
          : why // ignore: cast_nullable_to_non_nullable
              as String?,
      minimumAction: freezed == minimumAction
          ? _value.minimumAction
          : minimumAction // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ScheduleCategory,
      scheduledAt: null == scheduledAt
          ? _value.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ScheduleStatus,
      naggingCount: null == naggingCount
          ? _value.naggingCount
          : naggingCount // ignore: cast_nullable_to_non_nullable
              as int,
      snoozedUntil: freezed == snoozedUntil
          ? _value.snoozedUntil
          : snoozedUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$ScheduleEntityImpl extends _ScheduleEntity {
  const _$ScheduleEntityImpl(
      {required this.id,
      required this.userId,
      required this.title,
      this.description,
      this.why,
      this.minimumAction,
      this.category = ScheduleCategory.other,
      required this.scheduledAt,
      this.status = ScheduleStatus.pending,
      this.naggingCount = 0,
      this.snoozedUntil,
      this.completedAt,
      required this.createdAt,
      required this.updatedAt})
      : super._();

  @override
  final String id;
  @override
  final String userId;
  @override
  final String title;
  @override
  final String? description;

  /// 이게 왜 중요한가 (선택 입력, FocusPage + 알림에 표시)
  @override
  final String? why;

  /// 최소한 이것만 (선택 입력, FocusPage에서 시작 마찰 감소)
  @override
  final String? minimumAction;

  /// 카테고리 (FocusPage 포인트 컬러 결정)
  @override
  @JsonKey()
  final ScheduleCategory category;
  @override
  final DateTime scheduledAt;
  @override
  @JsonKey()
  final ScheduleStatus status;
  @override
  @JsonKey()
  final int naggingCount;
  @override
  final DateTime? snoozedUntil;
  @override
  final DateTime? completedAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ScheduleEntity(id: $id, userId: $userId, title: $title, description: $description, why: $why, minimumAction: $minimumAction, category: $category, scheduledAt: $scheduledAt, status: $status, naggingCount: $naggingCount, snoozedUntil: $snoozedUntil, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.why, why) || other.why == why) &&
            (identical(other.minimumAction, minimumAction) ||
                other.minimumAction == minimumAction) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.naggingCount, naggingCount) ||
                other.naggingCount == naggingCount) &&
            (identical(other.snoozedUntil, snoozedUntil) ||
                other.snoozedUntil == snoozedUntil) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      title,
      description,
      why,
      minimumAction,
      category,
      scheduledAt,
      status,
      naggingCount,
      snoozedUntil,
      completedAt,
      createdAt,
      updatedAt);

  /// Create a copy of ScheduleEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleEntityImplCopyWith<_$ScheduleEntityImpl> get copyWith =>
      __$$ScheduleEntityImplCopyWithImpl<_$ScheduleEntityImpl>(
          this, _$identity);
}

abstract class _ScheduleEntity extends ScheduleEntity {
  const factory _ScheduleEntity(
      {required final String id,
      required final String userId,
      required final String title,
      final String? description,
      final String? why,
      final String? minimumAction,
      final ScheduleCategory category,
      required final DateTime scheduledAt,
      final ScheduleStatus status,
      final int naggingCount,
      final DateTime? snoozedUntil,
      final DateTime? completedAt,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$ScheduleEntityImpl;
  const _ScheduleEntity._() : super._();

  @override
  String get id;
  @override
  String get userId;
  @override
  String get title;
  @override
  String? get description;

  /// 이게 왜 중요한가 (선택 입력, FocusPage + 알림에 표시)
  @override
  String? get why;

  /// 최소한 이것만 (선택 입력, FocusPage에서 시작 마찰 감소)
  @override
  String? get minimumAction;

  /// 카테고리 (FocusPage 포인트 컬러 결정)
  @override
  ScheduleCategory get category;
  @override
  DateTime get scheduledAt;
  @override
  ScheduleStatus get status;
  @override
  int get naggingCount;
  @override
  DateTime? get snoozedUntil;
  @override
  DateTime? get completedAt;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of ScheduleEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleEntityImplCopyWith<_$ScheduleEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
