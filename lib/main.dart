import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

import 'app.dart';
import 'shared/services/notification_service.dart';
import 'shared/services/background_service.dart';

/// 앱 진입점
///
/// 초기화 순서 (순서 변경 금지):
///   1. 타임존 설정
///   2. 로컬 알림 초기화
///   3. Workmanager 초기화
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. 타임존 초기화 (기기 로컬 타임존 자동 감지)
  tz.initializeTimeZones();
  final String localTz = _getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(localTz));

  // 2. 로컬 알림 초기화
  await NotificationService.instance.initialize();

  // 3. Workmanager 초기화
  await Workmanager().initialize(
    BackgroundService.callbackDispatcher,
    isInDebugMode: false,
  );

  runApp(
    const ProviderScope(
      child: BehaviorOSApp(),
    ),
  );
}

/// 기기 로컬 타임존 감지
///
/// DateTime.now().timeZoneName은 약어(KST 등)만 반환하므로
/// UTC 오프셋 기반으로 적절한 타임존을 선택.
String _getLocalTimezone() {
  final offset = DateTime.now().timeZoneOffset;
  final hours = offset.inHours;

  // 주요 타임존 매핑
  const tzMap = {
    9: 'Asia/Seoul',
    8: 'Asia/Shanghai',
    0: 'Europe/London',
    -5: 'America/New_York',
    -8: 'America/Los_Angeles',
    5: 'Asia/Karachi',
    -3: 'America/Sao_Paulo',
  };

  return tzMap[hours] ?? 'UTC';
}
