-- =============================================
-- MIGRATION: Add prototype_id isolation
-- Soundcheck — run this if you already ran schema.sql
-- Run in Supabase SQL Editor → New query
-- =============================================

-- Add prototype_id column to writable tables
ALTER TABLE warm_line_calls    ADD COLUMN IF NOT EXISTS prototype_id TEXT NOT NULL DEFAULT 'seed';
ALTER TABLE referrals          ADD COLUMN IF NOT EXISTS prototype_id TEXT NOT NULL DEFAULT 'seed';
ALTER TABLE care_journey_events ADD COLUMN IF NOT EXISTS prototype_id TEXT NOT NULL DEFAULT 'seed';
ALTER TABLE clients            ADD COLUMN IF NOT EXISTS prototype_id TEXT NOT NULL DEFAULT 'seed';
ALTER TABLE diagnoses          ADD COLUMN IF NOT EXISTS prototype_id TEXT NOT NULL DEFAULT 'seed';
ALTER TABLE medications        ADD COLUMN IF NOT EXISTS prototype_id TEXT NOT NULL DEFAULT 'seed';
ALTER TABLE allergies          ADD COLUMN IF NOT EXISTS prototype_id TEXT NOT NULL DEFAULT 'seed';
ALTER TABLE vitals              ADD COLUMN IF NOT EXISTS prototype_id TEXT NOT NULL DEFAULT 'seed';

-- Tag existing rows as seed data
UPDATE warm_line_calls     SET prototype_id = 'seed';
UPDATE referrals           SET prototype_id = 'seed';
UPDATE care_journey_events SET prototype_id = 'seed';
UPDATE clients             SET prototype_id = 'seed';
UPDATE diagnoses           SET prototype_id = 'seed';
UPDATE medications         SET prototype_id = 'seed';
UPDATE allergies           SET prototype_id = 'seed';
UPDATE vitals              SET prototype_id = 'seed';

-- Add indexes for fast prototype_id lookups
CREATE INDEX IF NOT EXISTS idx_warm_line_calls_prototype     ON warm_line_calls     (prototype_id);
CREATE INDEX IF NOT EXISTS idx_referrals_prototype           ON referrals           (prototype_id);
CREATE INDEX IF NOT EXISTS idx_care_journey_events_prototype ON care_journey_events (prototype_id);
CREATE INDEX IF NOT EXISTS idx_clients_prototype             ON clients             (prototype_id);
CREATE INDEX IF NOT EXISTS idx_diagnoses_prototype           ON diagnoses           (prototype_id);
CREATE INDEX IF NOT EXISTS idx_medications_prototype         ON medications         (prototype_id);
CREATE INDEX IF NOT EXISTS idx_allergies_prototype           ON allergies           (prototype_id);
CREATE INDEX IF NOT EXISTS idx_vitals_prototype              ON vitals              (prototype_id);

-- Done. Verify with:
-- SELECT prototype_id, count(*) FROM clients GROUP BY prototype_id;
