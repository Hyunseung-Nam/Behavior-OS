import 'package:flutter/material.dart';

/// 앱 테마 정의
///
/// 역할: 다크 테마 기반 (집중 UI 최적화)
/// 철학: 텍스트와 버튼 2개만 보이는 미니멀 디자인
abstract class AppTheme {
  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      colorScheme: const ColorScheme.dark(
        primary: Colors.white,
        onPrimary: Colors.black,
        surface: Color(0xFF111111),
        onSurface: Colors.white,
      ),
      useMaterial3: true,
    );
  }
}
