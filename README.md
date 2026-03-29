# Behavior OS (행동 운영체제)

> 해야 할 순간에 '행동'을 강제하는 개인 신호 시스템

---

## 개요

투두앱도, 습관앱도 아닌 **행동 트리거 시스템**.

핵심 메커니즘: **신호 → 행동 유도 → 단일 포커스 → 복구**

---

## 핵심 기능 (MVP)

| 기능 | 설명 |
|------|------|
| **다단계 알림** | 30분 전 인지 → 10분 전 준비 → 정각 행동 시작 |
| **Nagging** | 완료/연기 버튼을 누를 때까지 5분마다 반복 알림 |
| **Focus UI** | 지금 당장 해야 할 단 1개의 행동만 전체 화면에 표시 |
| **Recovery** | 놓친 일정을 보관함으로 이동 후 재스케줄링 유도 |

---

## 기술 스택

| 레이어 | 기술 |
|--------|------|
| UI | Flutter (iOS / Android / Web) |
| 상태 관리 | Riverpod |
| 로컬 알림 | flutter_local_notifications |
| 백그라운드 | Workmanager |
| 클라우드 DB | Supabase (인증 + 기기 간 백업) |
| 로컬 DB | Drift (SQLite, 오프라인 우선) |
| 라우터 | GoRouter (알림 딥링크 지원) |

---

## 프로젝트 구조

```
lib/
├── main.dart                        # 초기화 진입점
├── app.dart                         # 루트 위젯 (테마 + 라우터)
├── core/
│   ├── constants/                   # 전역 상수, 테마
│   └── router/                      # GoRouter 설정
├── features/
│   ├── schedule/                    # 일정 CRUD (Clean Architecture)
│   │   ├── data/                    # 모델, 데이터소스, Repository 구현
│   │   ├── domain/                  # 엔티티, Repository 인터페이스
│   │   └── presentation/            # Controller, Page, Widget
│   ├── focus/                       # 핵심 UI — 지금 당장 1개
│   └── missed/                      # 놓친 일정 보관함
└── shared/
    └── services/
        ├── notification_service.dart # 알림 CRUD 핵심
        └── background_service.dart   # Workmanager 백그라운드
```

---

## 알림 시스템 설계

```
일정 등록
    │
    ├── T-30분  인지 알림
    ├── T-10분  준비 알림
    ├── T+0     행동 트리거 알림
    └── T+5 ~ T+60  Nagging x12 (5분 간격 선(先)스케줄)
                        │
                        └── 60분 소진 시 Workmanager 재스케줄링
```

알림은 **서버 없이 기기 로컬에서 100% 동작** (오프라인 보장).
Supabase는 인증 및 기기 변경 시 데이터 백업 전용.

---

## 일정 상태 흐름

```
pending ──[알람]──► active ──[완료]──► completed
                        └──[연기]──► snoozed ──[만료]──► active
pending ──[60분 초과]──► missed ──[재스케줄]──► pending
```

---

## Supabase 스키마

`supabase/schema.sql` 참고.
주요 테이블: `schedules`, `notification_logs`
RLS 정책: 본인 데이터만 접근 가능.

---

## 로컬 실행

```bash
# 1. 의존성 설치
flutter pub get

# 2. 코드 생성 (freezed, riverpod)
dart run build_runner build --delete-conflicting-outputs

# 3. 웹으로 실행 (Chrome)
flutter run -d chrome --web-port 9090
```

환경 변수 주입 (Supabase 연동 시):
```bash
flutter run --dart-define=SUPABASE_URL=your_url --dart-define=SUPABASE_ANON_KEY=your_key
```

---

## 개발 로드맵

- [x] **Phase 1** — 프로젝트 구조 설계 + Flutter 프로젝트 초기화
- [ ] **Phase 2** — 알림 코어 (`flutter_local_notifications` + Workmanager)
- [ ] **Phase 3** — 로컬 DB + 상태관리 (Drift + Riverpod)
- [ ] **Phase 4** — 핵심 UI (Focus, 일정 등록, 놓친 보관함)
- [ ] **Phase 5** — Supabase 연동 (인증 + 기기 간 동기화)

---

## 설계 문서

상세 아키텍처는 [ARCHITECTURE.md](./ARCHITECTURE.md) 참고.
