# Behavior OS (행동 운영체제)

> 해야 할 순간에 '행동'을 유도하는 개인 신호 시스템

---

## 개요

투두앱도, 습관앱도 아닌 **행동 트리거 시스템**.

ADHD 또는 집중·시간 관리에 어려움이 있는 사람을 위해 설계됨.
과하게 통제하지 않되, 열 때마다 뭔가 달라져 있고 내가 변화를 만들고 있다는 느낌을 주는 것이 목표.

핵심 메커니즘: **신호 → 행동 유도 → 단일 포커스 → 복구**

---

## 핵심 기능

| 기능 | 설명 |
|------|------|
| **다단계 알림** | 30분 전 인지 → 10분 전 준비 → 정각 행동 시작 |
| **Nagging** | 완료/연기 버튼을 누를 때까지 반복 알림 (3회, 10분 간격) |
| **Focus UI** | 지금 당장 해야 할 단 1개의 행동만 전체 화면에 표시 |
| **카테고리 컬러** | 공부/운동/업무/휴식별 포인트 컬러 — 매번 다른 느낌 |
| **Why + 최소 행동** | 등록 시 "왜 중요한가" + "최소한 이것만" 입력 → FocusPage에 표시 |
| **경과 시간 메시지** | 늦었을 때 죄책감 대신 "지금 시작해도 됩니다" 상황별 메시지 |
| **Recovery** | 놓친 일정을 보관함으로 이동 후 재스케줄링 유도 |
| **캘린더 동기화** | 등록한 일정을 iOS 캘린더에 자동 추가 — 다른 일정과 겹침 여부 확인 |

---

## 기술 스택

| 레이어 | 기술 |
|--------|------|
| UI | Flutter (iOS / macOS) |
| 상태 관리 | Riverpod (code generation) |
| 로컬 알림 | flutter_local_notifications |
| 백그라운드 | Workmanager (iOS/Android 전용) |
| 로컬 DB | Drift (SQLite, 오프라인 100%) |
| 캘린더 연동 | device_calendar (iOS EventKit) |
| 라우터 | GoRouter |
| 코드 생성 | freezed, json_serializable, riverpod_generator |

---

## 프로젝트 구조

```
lib/
├── main.dart                                    # 앱 초기화 진입점 (알림·백그라운드 서비스 부트스트랩)
├── app.dart                                     # 루트 위젯 (ProviderScope + 테마 + GoRouter)
│
├── core/
│   ├── constants/
│   │   ├── app_constants.dart                   # 전역 상수 (nagging 주기, 타임아웃 등)
│   │   └── app_theme.dart                       # ThemeData (다크 테마 고정)
│   ├── providers/
│   │   └── repository_providers.dart            # AppDatabase 싱글턴 + Repository 주입
│   └── router/
│       ├── app_router.dart                      # GoRouter 경로 정의 (/, /schedule, /missed)
│       └── app_router.g.dart
│
├── features/
│   │
│   ├── focus/                                   # 핵심 UI — 지금 당장 1개의 행동
│   │   └── presentation/
│   │       ├── controllers/
│   │       │   ├── focus_controller.dart        # 긴급 일정 필터링·완료·연기 + syncStatuses
│   │       │   └── focus_controller.g.dart
│   │       └── pages/
│   │           └── focus_page.dart              # 카테고리 컬러 + why + 경과 시간 + 버튼
│   │
│   ├── schedule/                                # 일정 CRUD (Clean Architecture 3-Layer)
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── schedule_model.dart          # DB Row ↔ ScheduleEntity 변환
│   │   │   └── repositories/
│   │   │       └── schedule_repository_impl.dart # Drift ORM 기반 Repository 구현체
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── schedule_entity.dart         # 불변 도메인 엔티티 (freezed)
│   │   │   └── repositories/
│   │   │       └── schedule_repository.dart     # Repository 추상 인터페이스
│   │   └── presentation/
│   │       ├── controllers/
│   │       │   └── schedule_controller.dart     # CRUD 오케스트레이션
│   │       ├── pages/
│   │       │   ├── schedule_list_page.dart      # 일정 목록 (스와이프 삭제, 상태 배지)
│   │       │   └── schedule_form_page.dart      # 일정 등록 바텀시트
│   │       └── utils/
│   │           └── schedule_category_ui.dart    # 카테고리 → 컬러/레이블 매핑
│   │
│   └── missed/                                  # 놓친 일정 보관함
│       └── presentation/
│           ├── controllers/
│           │   └── missed_controller.dart       # missed 스트림 + 재스케줄링·삭제
│           └── pages/
│               └── missed_page.dart             # 보관함 목록 + 재스케줄링 UI
│
└── shared/
    ├── database/
    │   └── app_database.dart                    # Drift AppDatabase (ScheduleTable, v3)
    └── services/
        ├── notification_service.dart            # 알림 CRUD (T-30/T-10/T+0/Nagging)
        ├── background_service.dart              # Workmanager 백그라운드 태스크 (iOS/Android)
        └── calendar_service.dart                # iOS 캘린더 연동 (EventKit, 앱→캘린더 단방향)
```

### 화면 흐름

```
FocusPage (/)
  ├── [목록 아이콘] ──────────► ScheduleListPage (/schedule)
  │                                 ├── [보관함 아이콘] ──► MissedPage (/missed)
  │                                 └── [+ FAB] ────────► ScheduleFormPage (바텀시트)
  └── 완료 / 연기 버튼 ──► FocusController → DB + 알림 연동
```

### 레이어 의존성

```
presentation  →  domain  ←  data
(Controller)     (Entity)   (RepositoryImpl)
                 (Repository interface)
```

---

## 알림 시스템 설계

```
일정 등록
    │
    ├── T-30분  인지 알림
    ├── T-10분  준비 알림
    ├── T+0     행동 트리거 알림
    └── T+10 ~ T+30  Nagging x3 (10분 간격)
```

알림은 **서버 없이 기기 로컬에서 100% 동작** (오프라인 보장).

첫 실행 시 iOS 알림 권한 허용 다이얼로그가 자동으로 표시됨.
배너 지속 표시를 원하면 설정 → 알림 → behavior_os → 배너 스타일 → **지속** 으로 변경.

---

## 일정 상태 흐름

```
pending ──[scheduledAt 도래]──► active ──[완료]──► completed
                                    └──[연기]──► snoozed ──[만료]──► active
pending/active ──[60분 초과]──► missed ──[재스케줄]──► pending
```

---

## DB 스키마 (Drift, v2)

| 컬럼 | 타입 | 설명 |
|------|------|------|
| id | TEXT PK | UUID |
| title | TEXT | 일정 제목 |
| why | TEXT? | 왜 중요한가 (선택) |
| minimum_action | TEXT? | 최소한 이것만 (선택) |
| category | TEXT | study / exercise / work / rest / other |
| scheduled_at | DATETIME | 예정 시각 |
| status | TEXT | pending / active / snoozed / completed / missed |
| nagging_count | INTEGER | Nagging 횟수 |
| snoozed_until | DATETIME? | 연기 만료 시각 |
| completed_at | DATETIME? | 완료 시각 |
| calendar_event_id | TEXT? | iOS 캘린더 이벤트 ID (삭제 연동용) |

---

## 로컬 실행

```bash
# 1. 의존성 설치
flutter pub get

# 2. 코드 생성 (freezed, riverpod, drift)
dart run build_runner build --delete-conflicting-outputs

# 3. iOS 실행
flutter run -d [device-id]

# 4. macOS 실행 (테스트용, 알림 비활성)
flutter run -d macos
```

---

## 개발 로드맵

- [x] **Phase 1** — 프로젝트 구조 설계 + Flutter 초기화
- [x] **Phase 2** — 알림 코어 (flutter_local_notifications + Workmanager)
- [x] **Phase 3** — 로컬 DB + 핵심 UI (Drift, FocusPage, ScheduleListPage, MissedPage)
- [x] **Phase 4** — UX 개선
  - [x] why / minimumAction / category 필드 추가
  - [x] 카테고리별 포인트 컬러
  - [x] FocusPage 경과 시간 + 상황별 메시지
  - [x] syncStatuses() — pending→active 자동 전환
- [x] **Phase 5** — iOS 캘린더 연동 (device_calendar, 앱→캘린더 단방향)
- [ ] **Phase 6** — 알림 탭 딥링크 (`_onNotificationTapped` 구현)
- [ ] **Phase 7** — iOS BGTask 등록 (Info.plist BGTaskSchedulerPermittedIdentifiers)

---

## 설계 문서

상세 아키텍처는 [ARCHITECTURE.md](./ARCHITECTURE.md) 참고.
사용 방법은 [GUIDE.md](./GUIDE.md) 참고.
