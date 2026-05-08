import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/schedule_entity.dart';

part 'schedule_model.freezed.dart';
part 'schedule_model.g.dart';

/// Supabase/로컬DB 직렬화용 데이터 모델
///
/// 역할: JSON ↔ Domain Entity 변환 담당.
/// 책임: Supabase snake_case ↔ Dart camelCase 매핑
@freezed
class ScheduleModel with _$ScheduleModel {
  const factory ScheduleModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String title,
    String? description,
    String? why,
    @JsonKey(name: 'minimum_action') String? minimumAction,
    @Default('other') String category,
    @JsonKey(name: 'scheduled_at') required DateTime scheduledAt,
    @Default('pending') String status,
    @JsonKey(name: 'nagging_count') @Default(0) int naggingCount,
    @JsonKey(name: 'snoozed_until') DateTime? snoozedUntil,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ScheduleModel;

  const ScheduleModel._();

  factory ScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleModelFromJson(json);

  /// DB Row → Domain Entity 변환
  ScheduleEntity toEntity() => ScheduleEntity(
        id: id,
        userId: userId,
        title: title,
        description: description,
        why: why,
        minimumAction: minimumAction,
        category: ScheduleCategory.values.firstWhere(
          (c) => c.name == category,
          orElse: () => ScheduleCategory.other,
        ),
        scheduledAt: scheduledAt,
        status: ScheduleStatus.values.firstWhere(
          (s) => s.name == status,
          orElse: () => ScheduleStatus.pending,
        ),
        naggingCount: naggingCount,
        snoozedUntil: snoozedUntil,
        completedAt: completedAt,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
