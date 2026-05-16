/// 루틴 도메인 엔티티
///
/// 역할: 매일 반복 알림을 가진 루틴 항목을 표현하는 순수 도메인 객체.
/// 책임: 알림 시각 계산, 상태 보유.
class RoutineEntity {
  const RoutineEntity({
    required this.id,
    required this.title,
    required this.notifyHour,
    required this.notifyMinute,
    required this.isEnabled,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;

  /// 알림 시각 (0–23)
  final int notifyHour;

  /// 알림 분 (0–59)
  final int notifyMinute;

  /// 알림 활성화 여부
  final bool isEnabled;

  final DateTime createdAt;
  final DateTime updatedAt;

  /// 알림 시각을 "HH:mm" 형식으로 반환
  String get notifyTimeLabel {
    final h = notifyHour.toString().padLeft(2, '0');
    final m = notifyMinute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  RoutineEntity copyWith({
    String? title,
    int? notifyHour,
    int? notifyMinute,
    bool? isEnabled,
    DateTime? updatedAt,
  }) {
    return RoutineEntity(
      id: id,
      title: title ?? this.title,
      notifyHour: notifyHour ?? this.notifyHour,
      notifyMinute: notifyMinute ?? this.notifyMinute,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
