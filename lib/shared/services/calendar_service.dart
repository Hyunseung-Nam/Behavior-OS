import 'dart:io';

import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/foundation.dart';

/// iOS 캘린더 연동 서비스 (앱 → 캘린더 단방향)
///
/// 역할: Behavior OS 일정을 iOS 네이티브 캘린더에 추가/삭제.
/// 책임:
///   - "Behavior OS" 전용 캘린더 자동 생성 또는 기존 캘린더 재사용
///   - 이벤트 추가 (제목 + 시작 시각만 동기화)
///   - 이벤트 삭제 (일정 삭제/완료 시)
/// 외부 의존성: device_calendar (timezone 포함)
/// 플랫폼: iOS 전용 (macOS/기타 플랫폼은 no-op 처리)
class CalendarService {
  CalendarService._();
  static final CalendarService instance = CalendarService._();

  final DeviceCalendarPlugin _plugin = DeviceCalendarPlugin();
  String? _calendarId;

  static const _calendarName = 'Behavior OS';

  /// 일정을 iOS 캘린더에 추가
  ///
  /// Args:
  ///   title: 이벤트 제목 (일정 제목)
  ///   scheduledAt: 시작 시각
  /// Returns: 생성된 캘린더 이벤트 ID (삭제 시 사용). 실패 시 null.
  /// Side Effects: iOS 캘린더 권한 요청 팝업 (최초 1회)
  Future<String?> addEvent({
    required String title,
    required DateTime scheduledAt,
  }) async {
    if (!Platform.isIOS) return null;

    try {
      final calendarId = await _ensureCalendar();
      if (calendarId == null) return null;

      final start = TZDateTime.from(scheduledAt, local);
      final end = TZDateTime.from(
        scheduledAt.add(const Duration(hours: 1)),
        local,
      );

      final event = Event(calendarId, title: title, start: start, end: end);
      final result = await _plugin.createOrUpdateEvent(event);

      if (result?.isSuccess == true) return result!.data;
    } catch (e) {
      debugPrint('[CalendarService] addEvent error: $e');
    }
    return null;
  }

  /// iOS 캘린더에서 이벤트 삭제
  ///
  /// Args:
  ///   eventId: addEvent()가 반환한 이벤트 ID
  /// Side Effects: iOS 캘린더에서 해당 이벤트 제거
  Future<void> deleteEvent(String? eventId) async {
    if (!Platform.isIOS || eventId == null) return;

    try {
      final calendarId = await _ensureCalendar();
      if (calendarId == null) return;
      await _plugin.deleteEvent(calendarId, eventId);
    } catch (e) {
      debugPrint('[CalendarService] deleteEvent error: $e');
    }
  }

  /// "Behavior OS" 캘린더 ID 확보 (없으면 생성, 있으면 재사용)
  ///
  /// Returns: calendarId. 권한 거부 또는 실패 시 null.
  Future<String?> _ensureCalendar() async {
    if (_calendarId != null) return _calendarId;

    final permResult = await _plugin.requestPermissions();
    if (permResult.data != true) return null;

    final result = await _plugin.retrieveCalendars();
    final calendars = result.data?.toList() ?? [];

    // 기존 "Behavior OS" 캘린더 탐색
    for (final cal in calendars) {
      if (cal.name == _calendarName && cal.isReadOnly == false) {
        _calendarId = cal.id;
        return _calendarId;
      }
    }

    // 신규 캘린더 생성
    final createResult = await _plugin.createCalendar(_calendarName);
    if (createResult.isSuccess && createResult.data != null) {
      _calendarId = createResult.data;
      return _calendarId;
    }

    // Fallback: 첫 번째 쓰기 가능 캘린더 사용
    for (final cal in calendars) {
      if (cal.isReadOnly == false) {
        _calendarId = cal.id;
        return _calendarId;
      }
    }

    return null;
  }
}
