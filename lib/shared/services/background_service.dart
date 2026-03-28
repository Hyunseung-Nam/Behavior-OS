import 'package:workmanager/workmanager.dart';

import '../../core/constants/app_constants.dart';

/// 백그라운드 서비스
///
/// 역할: Workmanager를 통한 백그라운드 Nagging 재스케줄링.
/// 문제 배경:
///   flutter_local_notifications는 최대 64개(Android) / 64개(iOS) 알림 제한.
///   선(先)스케줄 12개(60분)가 소진되면, Workmanager가 깨어나 추가 Nagging 등록.
/// 외부 의존성: workmanager
class BackgroundService {
  BackgroundService._();

  /// Workmanager 콜백 진입점 (top-level 또는 static 필수)
  ///
  /// Side Effects: 미완료 일정 확인 후 추가 Nagging 알림 등록
  @pragma('vm:entry-point')
  static Future<void> callbackDispatcher() async {
    Workmanager().executeTask((taskName, inputData) async {
      switch (taskName) {
        case AppConstants.naggingTaskName:
          await _handleNaggingCheck(inputData);
          break;
      }
      return Future.value(true);
    });
  }

  /// 미완료 일정에 대한 추가 Nagging 스케줄링
  ///
  /// Args:
  ///   inputData: {'scheduleId': String, 'naggingCount': int}
  static Future<void> _handleNaggingCheck(Map<String, dynamic>? inputData) async {
    if (inputData == null) return;
    // TODO: 로컬 DB에서 해당 일정 상태 확인 후
    //       여전히 active(미완료)면 추가 Nagging 알림 등록
    //       completed/missed면 아무것도 안 함
  }

  /// 백그라운드 Nagging 작업 등록
  ///
  /// Args:
  ///   scheduleId: 대상 일정 ID
  ///   delayMinutes: 첫 백그라운드 체크까지 지연 시간 (기본 65분 = 선스케줄 소진 후)
  static Future<void> registerNaggingTask({
    required String scheduleId,
    int delayMinutes = 65,
  }) async {
    await Workmanager().registerOneOffTask(
      '${AppConstants.naggingTaskName}_$scheduleId',
      AppConstants.naggingTaskName,
      initialDelay: Duration(minutes: delayMinutes),
      inputData: {'scheduleId': scheduleId},
      tag: AppConstants.naggingTaskTag,
      constraints: Constraints(
        networkType: NetworkType.not_required,
        requiresBatteryNotLow: false,
      ),
    );
  }

  /// 특정 일정의 백그라운드 작업 취소
  ///
  /// Args:
  ///   scheduleId: 취소할 일정 ID
  static Future<void> cancelNaggingTask(String scheduleId) async {
    await Workmanager().cancelByUniqueName(
      '${AppConstants.naggingTaskName}_$scheduleId',
    );
  }
}
