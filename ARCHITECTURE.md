# Behavior OS — Architecture

## 핵심 원칙
> "해야 할 순간에 행동을 강제하는 개인 신호 시스템"
> 서버 없이 100% 오프라인 알람 동작 보장.

---

## 기술 스택

| 레이어 | 기술 | 이유 |
|--------|------|------|
| UI | Flutter (iOS / macOS) | iOS/macOS 동시 지원 |
| 상태관리 | Riverpod (code generation) | Stream 기반 알림↔UI 동기화 |
| 로컬 알림 | flutter_local_notifications | 오프라인 100% 동작 |
| 백그라운드 | Workmanager (iOS 전용) | Nagging 재스케줄링 |
| 로컬 DB | Drift (SQLite) | 오프라인 우선, 스키마 마이그레이션 |
| 캘린더 연동 | device_calendar (iOS EventKit) | 앱→캘린더 단방향 동기화 |
| 라우터 | GoRouter | 화면 전환 + 딥링크 준비 |
| 코드 생성 | freezed / riverpod_generator / drift_dev | 불변 모델, Provider, ORM |

---

## 디렉토리 구조

```
lib/
├── main.dart                                    # 앱 초기화 진입점 (알림·백그라운드 서비스 부트스트랩)
├── app.dart                                     # 루트 위젯 (ConsumerStatefulWidget + AppLifecycleListener)
│
├── core/
│   ├── constants/
│   │   ├── app_constants.dart                   # 전역 상수 (nagging 주기, 타임아웃 등)
│   │   └── app_theme.dart                       # ThemeData (다크 테마 고정)
│   ├── providers/
│   │   └── repository_providers.dart            # AppDatabase 싱글턴 + Repository 주입
│   └── router/
│       ├── app_router.dart                      # GoRouter 경로 정의
│       └── app_router.g.dart
│
├── features/
│   │
│   ├── focus/                                   # 핵심 UI — 지금 당장 1개의 행동
│   │   └── presentation/
│   │       ├── controllers/
│   │       │   ├── focus_controller.dart        # 긴급 일정 필터링·완료·연기 + 1분 타이머 sync
│   │       │   └── focus_controller.g.dart
│   │       └── pages/
│   │           └── focus_page.dart              # 카테고리 컬러 + why + 경과 시간 + 버튼
│   │
│   ├── schedule/                                # 일정 CRUD (Clean Architecture 3-Layer)
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── schedule_model.dart
│   │   │   └── repositories/
│   │   │       └── schedule_repository_impl.dart # Drift ORM 기반 Repository 구현체
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── schedule_entity.dart         # 불변 도메인 엔티티 (freezed)
│   │   │   └── repositories/
│   │   │       └── schedule_repository.dart     # Repository 추상 인터페이스
│   │   └── presentation/
│   │       ├── controllers/
│   │       │   └── schedule_controller.dart     # CRUD 오케스트레이션 (create/edit/delete)
│   │       ├── pages/
│   │       │   ├── schedule_list_page.dart      # 일정 목록 (탭 수정, 스와이프 삭제)
│   │       │   └── schedule_form_page.dart      # 일정 등록/수정 바텀시트
│   │       └── utils/
│   │           └── schedule_category_ui.dart    # 카테고리 → 컬러/레이블 매핑
│   │
│   ├── missed/                                  # 놓친 일정 보관함
│   │   └── presentation/
│   │       ├── controllers/
│   │       │   └── missed_controller.dart       # missed 스트림 + 재스케줄링·삭제
│   │       └── pages/
│   │           └── missed_page.dart             # 보관함 목록 + 재스케줄링 UI
│   │
│   ├── history/                                 # 완료 일정 기록
│   │   └── presentation/
│   │       └── pages/
│   │           └── history_page.dart            # 날짜별 그룹 완료 기록 + 정시/지연 표시
│   │
│   └── routine/                                 # 매일 반복 루틴 알림
│       ├── data/
│       │   └── repositories/
│       │       └── routine_repository_impl.dart # Drift ORM 기반 구현체
│       ├── domain/
│       │   ├── entities/
│       │   │   └── routine_entity.dart          # 루틴 도메인 엔티티
│       │   └── repositories/
│       │       └── routine_repository.dart      # Repository 추상 인터페이스
│       └── presentation/
│           ├── controllers/
│           │   └── routine_controller.dart      # CRUD 오케스트레이션 (StreamNotifierProvider)
│           └── pages/
│               └── routine_settings_page.dart   # 루틴 설정 화면 (추가/수정/삭제/토글)
│
└── shared/
    ├── database/
    │   └── app_database.dart                    # Drift AppDatabase (ScheduleTable + RoutineTable, v4)
    └── services/
        ├── notification_service.dart            # 일정 알림 + 루틴 매일 반복 알림
        ├── background_service.dart              # Workmanager 백그라운드 태스크 (iOS 전용)
        └── calendar_service.dart                # iOS 캘린더 연동 (EventKit, 앱→캘린더 단방향)
```

---

## 알림 시스템 아키텍처

```
일정 등록
    │
    ▼
NotificationService.scheduleAll()
    │
    ├── T-30분: early_reminder  (알림 ID: hash*100 + 0)
    ├── T-10분: prep_reminder   (알림 ID: hash*100 + 1)
    ├── T+0:   trigger          (알림 ID: hash*100 + 2)
    └── T+10, T+20, T+30: nagging x3 (ID: hash*100 + 3~5)
            │
            └── Workmanager 백그라운드 태스크 (iOS 전용)
                    │
                    └── 로컬 DB 상태 확인
                            ├── 완료/연기됨 → 아무것도 안 함
                            └── 미완료 → missed 전환

사용자 응답
    ├── [행동 완료] → cancelAll() + cancelNaggingTask()
    └── [10분 연기] → cancelNagging() + 10분 후 snooze 알림
```

---

## 캘린더 연동 아키텍처

```
일정 등록 (createSchedule)
    │
    ├── DB 저장
    ├── 알림 스케줄링
    └── CalendarService.addEvent(title, scheduledAt)
            │
            ├── iOS: EventKit 권한 요청 (최초 1회)
            ├── "Behavior OS" 캘린더 탐색 or 생성
            ├── 이벤트 추가 (제목 + 시작시각)
            └── eventId → DB calendarEventId 컬럼 저장

일정 삭제 / 재스케줄
    └── CalendarService.deleteEvent(calendarEventId)
            └── iOS 캘린더에서 이벤트 제거

플랫폼 가드: macOS는 모든 캘린더 연동 no-op
```

---

## 상태 흐름

```
pending ──[scheduledAt 도래]──► active ──[완료]──► completed
                                    └──[연기]──► snoozed ──[만료]──► active
pending/active ──[60분 초과]──► missed ──[재스케줄]──► pending
```

`syncStatuses()` — 앱 포그라운드 진입 시 자동 호출하여 상태 동기화.

---

## DB 스키마 (Drift, v4)

### ScheduleTable

| 컬럼 | 타입 | 설명 |
|------|------|------|
| id | TEXT PK | UUID |
| user_id | TEXT | 'local' 고정 |
| title | TEXT | 일정 제목 |
| description | TEXT? | 메모 (선택) |
| why | TEXT? | 왜 중요한가 (선택) |
| minimum_action | TEXT? | 최소한 이것만 (선택) |
| category | TEXT | study / exercise / work / rest / other |
| scheduled_at | DATETIME | 예정 시각 |
| status | TEXT | pending / active / snoozed / completed / missed |
| nagging_count | INTEGER | Nagging 횟수 |
| snoozed_until | DATETIME? | 연기 만료 시각 |
| completed_at | DATETIME? | 완료 시각 |
| calendar_event_id | TEXT? | iOS 캘린더 이벤트 ID |
| created_at | DATETIME | 생성 시각 |
| updated_at | DATETIME | 최종 수정 시각 |

### RoutineTable

| 컬럼 | 타입 | 설명 |
|------|------|------|
| id | TEXT PK | UUID |
| title | TEXT | 루틴 제목 |
| notify_hour | INTEGER | 알림 시 (0–23) |
| notify_minute | INTEGER | 알림 분 (0–59) |
| is_enabled | BOOLEAN | 알림 활성화 여부 (기본 true) |
| created_at | DATETIME | 생성 시각 |
| updated_at | DATETIME | 최종 수정 시각 |

마이그레이션 이력:
- v1 → v2: `why`, `minimum_action`, `category` 추가
- v2 → v3: `calendar_event_id` 추가
- v3 → v4: `RoutineTable` 신규 생성

---

## 백그라운드↔UI 동기화

```
Workmanager (백그라운드, iOS 전용)
    │ 로컬 DB (Drift) 업데이트
    ▼
Drift Stream
    │ watchSchedules() Stream
    ▼
Riverpod StreamProvider (focusControllerProvider)
    │ 자동 갱신
    ▼
FocusPage rebuild
```

### 실시간 상태 동기화 트리거

| 트리거 | 처리 |
|--------|------|
| FocusController 초기 빌드 | `syncStatuses()` 1회 실행 |
| 1분 주기 타이머 | `syncStatuses()` 반복 실행 |
| 앱 포그라운드 복귀 | `AppLifecycleListener.onResume` → `syncStatuses()` |

핵심 알람 동작은 100% 로컬 (오프라인 보장). 서버 의존성 없음.

---

## 플랫폼별 기능 차이

| 기능 | iOS | macOS |
|------|-----|-------|
| 일정 CRUD | O | O |
| 로컬 알림 | O | O (제한적) |
| Workmanager 백그라운드 | O | X |
| 캘린더 연동 | O | X |

---

## 개발 로드맵

- [x] **Phase 1** — 프로젝트 구조 설계 + Flutter 초기화
- [x] **Phase 2** — 알림 코어 (flutter_local_notifications + Workmanager)
- [x] **Phase 3** — 로컬 DB + 핵심 UI (Drift, FocusPage, ScheduleListPage, MissedPage)
- [x] **Phase 4** — UX 개선 (카테고리 컬러, why/minimumAction, 경과 시간, syncStatuses)
- [x] **Phase 5** — iOS 캘린더 연동 (device_calendar, 앱→캘린더 단방향)
- [x] **Phase 6** — 기능 확장
  - [x] 일정 수정 (탭 → 수정 폼, updateSchedule)
  - [x] 실시간 갱신 (1분 타이머 + AppLifecycleListener)
  - [x] 캘린더 중복 수정 (missed 전환 시 이벤트 삭제)
  - [x] 루틴 알림 (RoutineTable, 매일 반복, 설정 화면)
  - [x] 완료 기록 화면 (날짜별 그룹, 정시/지연 표시)
- [ ] **Phase 7** — 알림 탭 딥링크 (`_onNotificationTapped` 구현)
- [ ] **Phase 8** — iOS BGTask 등록 (Info.plist BGTaskSchedulerPermittedIdentifiers)
