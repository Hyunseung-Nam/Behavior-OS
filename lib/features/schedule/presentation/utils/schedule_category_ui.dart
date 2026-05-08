import 'package:flutter/material.dart';

import '../../domain/entities/schedule_entity.dart';

/// ScheduleCategory UI 확장
///
/// 역할: 도메인 enum에 Flutter 전용 색상/레이블 매핑 제공.
/// FocusPage, ScheduleFormPage 등 공통 사용.
extension ScheduleCategoryUI on ScheduleCategory {
  String get label => switch (this) {
        ScheduleCategory.study => '공부',
        ScheduleCategory.exercise => '운동',
        ScheduleCategory.work => '업무',
        ScheduleCategory.rest => '휴식',
        ScheduleCategory.other => '기타',
      };

  Color get color => switch (this) {
        ScheduleCategory.study => const Color(0xFF4A90D9),
        ScheduleCategory.exercise => const Color(0xFFE8874A),
        ScheduleCategory.work => const Color(0xFF9B6DD9),
        ScheduleCategory.rest => const Color(0xFF4DB87A),
        ScheduleCategory.other => const Color(0xFF888888),
      };
}
