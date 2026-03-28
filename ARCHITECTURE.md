# Behavior OS — Architecture

## 핵심 원칙
> "해야 할 순간에 행동을 강제하는 개인 신호 시스템"
> 서버 없이 100% 오프라인 알람 동작 보장.

---

## 기술 스택

| 레이어 | 기술 | 이유 |
|--------|------|------|
| UI | Flutter | iOS/Android 동시 출시 |
| 상태관리 | Riverpod | Stream 기반 알람↔UI 동기화 |
| 로컬 알림 | flutter_local_notifications | 오프라인 100% 동작 |
| 백그라운드 | Workmanager | Nagging 60분 이후 재스케줄 |
| 클라우드 DB | Supabase | 인증 + 기기 변경 백업 |
| 로컬 DB | Drift (SQLite) | 오프라인 캐시 + 오프라인 우선 |
| 라우터 | GoRouter | 알림 딥링크 지원 |

---

## 디렉토리 구조

```
lib/
├── main.dart                    # 앱 진입점 (초기화 순서 중요)
├── app.dart                     # 루트 위젯 (테마 + 라우터)
│
├── core/                        # 앱 전역 공통
│   ├── constants/
│   │   ├── app_constants.dart   # 전역 상수 (알림 설정값 등)
│   │   └── app_theme.dart       # 다크 테마
│   ├── errors/                  # 에러 타입 정의
│   ├── router/
│   │   └── app_router.dart      # GoRouter 설정 + 딥링크
│   └── utils/                   # 날짜 포매터 등 유틸
│
├── features/
│   ├── schedule/                # 일정 등록/관리 Feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── schedule_local_datasource.dart   # Drift
│   │   │   │   └── schedule_remote_datasource.dart  # Supabase
│   │   │   ├── models/
│   │   │   │   └── schedule_model.dart              # JSON 직렬화
│   │   │   └── repositories/
│   │   │       └── schedule_repository_impl.dart    # 구현체
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── schedule_entity.dart             # 순수 도메인
│   │   │   ├── repositories/
│   │   │   │   └── schedule_repository.dart         # 인터페이스
│   │   │   └── usecases/                            # 비즈니스 유즈케이스
│   │   └── presentation/
│   │       ├── controllers/                         # Riverpod controllers
│   │       ├── pages/                               # 화면
│   │       └── widgets/                             # 재사용 위젯
│   │
│   ├── focus/                   # 핵심: 지금 당장 할 것 1개 표시
│   │   └── presentation/
│   │       ├── controllers/
│   │       │   └── focus_controller.dart            # 긴급도 우선순위 로직
│   │       └── pages/
│   │           └── focus_page.dart                  # 메인 화면
│   │
│   └── missed/                  # 놓친 일정 보관함 + 재스케줄링
│       └── presentation/
│
└── shared/
    ├── services/
    │   ├── notification_service.dart    # 알림 CRUD 핵심
    │   └── background_service.dart      # Workmanager 백그라운드
    ├── theme/
    └── widgets/                         # 공통 위젯
```

---

## 알림 시스템 아키텍처

```
일정 등록
    │
    ▼
NotificationService.scheduleAllNotifications()
    │
    ├── T-30분: early_reminder (알림 ID: hash*100 + 0)
    ├── T-10분: prep_reminder  (알림 ID: hash*100 + 1)
    ├── T+0:   trigger         (알림 ID: hash*100 + 2)
    └── T+5, T+10 ... T+60: nagging x12 (ID: hash*100 + 11~22)
            │
            └── [60분 소진 시] Workmanager 백그라운드 작업 발동
                    │
                    └── 로컬 DB 상태 확인
                            ├── 완료됨 → 아무것도 안 함
                            └── 미완료 → 추가 Nagging 등록

사용자 응답
    ├── [완료] → cancelAllNotifications() + cancelNaggingTask()
    └── [10분 연기] → cancelNaggingNotifications() + 10분 후 재스케줄
```

---

## 상태 흐름

```
pending ──[알람 울림]──► active ──[완료]──► completed
           │                    └──[연기]──► snoozed ──[만료]──► active
           └──[60분 초과]──► missed ──[재스케줄]──► pending
```

---

## 백그라운드↔UI 동기화

```
Workmanager (백그라운드)
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

Supabase Realtime은 **다기기 동기화**에만 사용.
핵심 알람 동작은 100% 로컬 (오프라인 보장).

---

## 개발 로드맵

### Phase 1 — 알람 코어 (1~2주)
- [ ] Flutter 프로젝트 생성 (`flutter create .`)
- [ ] `pubspec.yaml` 의존성 설치
- [ ] `flutter_local_notifications` 초기화 + 권한 설정
- [ ] 타임존 설정 검증
- [ ] `NotificationService` 단위 테스트 (시간별 알림 ID 확인)
- [ ] `Workmanager` 백그라운드 태스크 연동

### Phase 2 — 로컬 데이터 + 상태관리 (1~2주)
- [ ] `Drift` 로컬 DB 스키마 + DAO 작성
- [ ] `ScheduleRepositoryImpl` 구현 (로컬 전용)
- [ ] Riverpod Provider 연결
- [ ] 일정 CRUD + 알림 연동 통합 테스트

### Phase 3 — 핵심 UI (1주)
- [ ] `FocusPage` (지금 당장 1개)
- [ ] 일정 등록 화면
- [ ] 놓친 일정 보관함 + 재스케줄링 화면
- [ ] GoRouter 딥링크 (알림 탭 → Focus 화면)

### Phase 4 — Supabase 연동 (1주)
- [ ] `supabase/schema.sql` Supabase에 적용
- [ ] 인증 (이메일/소셜 로그인)
- [ ] `ScheduleRemoteDatasource` 구현
- [ ] Offline-first 병합 전략 (로컬 우선, 네트워크 복구 시 동기화)
- [ ] iOS/Android 배포 설정 (알림 권한, Background Modes)
