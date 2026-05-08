// Behavior OS 앱 기본 위젯 테스트

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:behavior_os/app.dart';

void main() {
  testWidgets('앱이 오류 없이 실행되는지 확인', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: BehaviorOSApp(),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
