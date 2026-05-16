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
| **Nagging** | 완료/연기 버튼을 누를 때까지 5분 간격 최대 12회 반복 알림 |
| **Focus UI** | 지금 당장 해야 할 단 1개의 행동만 전체 화면에 표시 |
| **카테고리 컬러** | 공부/운동/업무/휴식별 포인트 컬러 |
| **Why + 최소 행동** | 등록 시 "왜 중요한가" + "최소한 이것만" 입력 → FocusPage에 표시 |
| **일정 수정** | 등록된 일정을 탭해 수정 — 알림·캘린더 자동 재등록 |
| **Recovery** | 놓친 일정을 보관함으로 이동 후 재스케줄링 유도 |
| **캘린더 동기화** | 등록한 일정을 iOS 캘린더에 자동 추가/삭제 |
| **루틴 알림** | 매일 반복 알림 설정 — 설정 화면에서 항목별 시각·on/off 관리 |
| **완료 기록** | 날짜별 완료 일정 기록 + 예정 대비 완료 시각 표시 |
| **실시간 갱신** | 포그라운드 복귀 시 즉시 상태 동기화, 1분 주기 자동 갱신 |

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
├── main.dart
├── app.dart                                     # AppLifecycleListener — 포그라운드 복귀 시 sync
│
├── core/
│   ├── providers/
│   │   └── repository_providers.dart            # AppDatabase + Schedule/RoutineRepository 주입
│   └── router/
│       └── app_router.dart                      # /, /schedule, /missed, /history, /settings/routines
│
├── features/
│   ├── focus/                                   # 핵심 UI — 지금 당장 1개의 행동
│   ├── schedule/                                # 일정 CRUD + 수정 (Clean Architecture 3-Layer)
│   ├── missed/                                  # 놓친 일정 보관함
│   ├── history/                                 # 완료 기록 (날짜별 그룹)
│   └── routine/                                 # 매일 반복 루틴 알림 설정
│
└── shared/
    ├── database/
    │   └── app_database.dart                    # Drift AppDatabase (ScheduleTable + RoutineTable, v4)
    └── services/
        ├── notification_service.dart            # 일정 알림 + 루틴 매일 반복 알림
        ├── background_service.dart              # Workmanager (iOS 전용)
        └── calendar_service.dart                # iOS 캘린더 연동
```

### 화면 흐름

```
FocusPage (/)
  └── [목록 아이콘] ──► ScheduleListPage (/schedule)
                            ├── [루틴 아이콘] ──► RoutineSettingsPage (/settings/routines)
                            ├── [기록 아이콘] ──► HistoryPage (/history)
                            ├── [보관함 아이콘] ─► MissedPage (/missed)
                            ├── [항목 탭] ──────► ScheduleFormPage (수정 모드, 바텀시트)
                            └── [+ FAB] ────────► ScheduleFormPage (등록 모드, 바텀시트)
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

## DB 스키마 (Drift, v4)

**ScheduleTable** — 일정

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
| calendar_event_id | TEXT? | iOS 캘린더 이벤트 ID |

**RoutineTable** — 루틴

| 컬럼 | 타입 | 설명 |
|------|------|------|
| id | TEXT PK | UUID |
| title | TEXT | 루틴 제목 |
| notify_hour | INTEGER | 알림 시 (0–23) |
| notify_minute | INTEGER | 알림 분 (0–59) |
| is_enabled | BOOLEAN | 알림 활성화 여부 |

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
- [x] **Phase 4** — UX 개선 (카테고리 컬러, why/minimumAction, syncStatuses)
- [x] **Phase 5** — iOS 캘린더 연동 (device_calendar, 앱→캘린더 단방향)
- [x] **Phase 6** — 기능 확장
  - [x] 일정 수정 기능
  - [x] 실시간 갱신 (타이머 + 생명주기)
  - [x] 루틴 알림 설정 화면
  - [x] 완료 기록 화면
- [ ] **Phase 7** — 알림 탭 딥링크 (`_onNotificationTapped` 구현)
- [ ] **Phase 8** — iOS BGTask 등록 (Info.plist BGTaskSchedulerPermittedIdentifiers)

---

## 설계 문서

상세 아키텍처는 [ARCHITECTURE.md](./ARCHITECTURE.md) 참고.
사용 방법은 [GUIDE.md](./GUIDE.md) 참고.
