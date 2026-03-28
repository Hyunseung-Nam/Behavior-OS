/// 앱 전역 상수
///
/// 역할: 하드코딩 방지. 모든 고정값은 여기서 관리.
/// 주의: supabaseUrl, supabaseAnonKey는 .env 또는 --dart-define으로 주입할 것.
abstract class AppConstants {
  // Supabase - dart-define으로 주입: --dart-define=SUPABASE_URL=xxx
  static const String supabaseUrl =
      String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  static const String supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');

  // 알림 채널
  static const String notificationChannelId = 'behavior_os_channel';
  static const String notificationChannelName = '행동 트리거';
  static const String notificationChannelDesc = '행동 시작 신호 알림';

  // Nagging 설정
  static const int naggingIntervalMinutes = 5;  // 5분마다 반복
  static const int maxPrescheduledNagging = 12; // 최대 1시간치 선(先)스케줄

  // 다단계 알림 오프셋 (분)
  static const int reminderEarlyMinutes = 30;
  static const int reminderPrepMinutes = 10;

  // Workmanager task 이름
  static const String naggingTaskName = 'behavior_os_nagging_check';
  static const String naggingTaskTag = 'nagging';
}
