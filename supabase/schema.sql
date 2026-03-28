-- ============================================================
-- Behavior OS - Supabase Database Schema
-- ============================================================

-- ① schedules 테이블: 핵심 일정 데이터
CREATE TABLE public.schedules (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id       UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    title         TEXT NOT NULL,
    description   TEXT,
    scheduled_at  TIMESTAMPTZ NOT NULL,

    -- 상태: pending / active / snoozed / completed / missed
    status        TEXT NOT NULL DEFAULT 'pending'
                  CHECK (status IN ('pending', 'active', 'snoozed', 'completed', 'missed')),

    nagging_count INT NOT NULL DEFAULT 0,    -- Nagging 누적 횟수
    snoozed_until TIMESTAMPTZ,               -- 연기 만료 시각
    completed_at  TIMESTAMPTZ,               -- 완료 시각

    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 인덱스: 사용자별 일정 조회 (앱 주요 쿼리)
CREATE INDEX idx_schedules_user_id ON public.schedules(user_id);
-- 인덱스: 상태별 필터링 (active/pending 우선 조회)
CREATE INDEX idx_schedules_status ON public.schedules(user_id, status);
-- 인덱스: 시간순 정렬
CREATE INDEX idx_schedules_scheduled_at ON public.schedules(user_id, scheduled_at);

-- updated_at 자동 갱신 트리거
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER schedules_updated_at
    BEFORE UPDATE ON public.schedules
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ② notification_logs 테이블: 알림 발송 이력
CREATE TABLE public.notification_logs (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    schedule_id     UUID NOT NULL REFERENCES public.schedules(id) ON DELETE CASCADE,
    user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

    -- 알림 타입: early_reminder / prep_reminder / trigger / nagging
    type            TEXT NOT NULL
                    CHECK (type IN ('early_reminder', 'prep_reminder', 'trigger', 'nagging')),

    sent_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    acknowledged_at TIMESTAMPTZ  -- 사용자가 응답한 시각 (null = 미응답)
);

CREATE INDEX idx_notification_logs_schedule ON public.notification_logs(schedule_id);

-- ============================================================
-- Row Level Security (RLS) - 본인 데이터만 접근 가능
-- ============================================================

ALTER TABLE public.schedules ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notification_logs ENABLE ROW LEVEL SECURITY;

-- schedules RLS
CREATE POLICY "users can manage own schedules"
    ON public.schedules
    FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- notification_logs RLS
CREATE POLICY "users can view own logs"
    ON public.notification_logs
    FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- ============================================================
-- Realtime 활성화 (기기 간 동기화)
-- ============================================================
ALTER PUBLICATION supabase_realtime ADD TABLE public.schedules;
