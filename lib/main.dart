import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

import 'app.dart';
import 'shared/services/notification_service.dart';
import 'shared/services/background_service.dart';

/// 앱 진입점
///
/// 초기화 순서 (순서 변경 금지):
///   1. 타임존 설정 — flutter_local_notifications보다 반드시 먼저
///   2. 로컬 알림 초기화 — 권한 요청 포함
///   3. Workmanager 초기화 — Nagging 백그라운드 재스케줄링
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. 타임존 초기화
  tz.initializeTimeZones();
  final String localTz = await FlutterTimezone.getLocalTimezone();
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
