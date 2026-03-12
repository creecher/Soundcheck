-- =============================================
-- SOUNDCHECK — Supabase Schema
-- Chorus Prototype Playground
-- Run this in your Supabase SQL editor to set up all tables
-- =============================================

-- Programs
CREATE TABLE programs (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  icon_type TEXT,
  active_client_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Staff / Care Coordinators
CREATE TABLE staff (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  role TEXT NOT NULL,
  title TEXT,
  program_id TEXT REFERENCES programs(id),
  email TEXT,
  avatar_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Clients
CREATE TABLE clients (
  id TEXT PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  preferred_name TEXT,
  pronouns TEXT,
  dob DATE,
  age INTEGER,
  phone_primary TEXT,
  phone_secondary TEXT,
  assigned_clinician TEXT,
  program_id TEXT REFERENCES programs(id),
  risk_level TEXT CHECK (risk_level IN ('low', 'routine', 'high', 'crisis')) DEFAULT 'routine',
  insurance_type TEXT,
  avatar_url TEXT,
  ai_summary TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Diagnoses
CREATE TABLE diagnoses (
  id TEXT PRIMARY KEY,
  client_id TEXT REFERENCES clients(id),
  diagnosis_name TEXT NOT NULL,
  icd_code TEXT,
  diagnosed_date DATE,
  status TEXT CHECK (status IN ('current', 'past')) DEFAULT 'current',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Medications
CREATE TABLE medications (
  id TEXT PRIMARY KEY,
  client_id TEXT REFERENCES clients(id),
  medication_name TEXT NOT NULL,
  dosage TEXT,
  condition TEXT,
  status TEXT CHECK (status IN ('active', 'missed', 'discontinued')) DEFAULT 'active',
  due_date DATE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Allergies
CREATE TABLE allergies (
  id TEXT PRIMARY KEY,
  client_id TEXT REFERENCES clients(id),
  allergen TEXT NOT NULL,
  severity TEXT CHECK (severity IN ('mild', 'moderate', 'severe')) DEFAULT 'moderate',
  note TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Vitals
CREATE TABLE vitals (
  id TEXT PRIMARY KEY,
  client_id TEXT REFERENCES clients(id),
  type TEXT NOT NULL,
  value TEXT NOT NULL,
  unit TEXT,
  status TEXT CHECK (status IN ('normal', 'elevated', 'low', 'critical')) DEFAULT 'normal',
  recorded_at TIMESTAMPTZ DEFAULT NOW()
);

-- Warm Line Calls
CREATE TABLE warm_line_calls (
  id TEXT PRIMARY KEY,
  client_id TEXT REFERENCES clients(id),
  caller_name TEXT NOT NULL,
  phone TEXT,
  relationship TEXT CHECK (relationship IN ('self', 'family', 'other')) DEFAULT 'self',
  priority TEXT CHECK (priority IN ('routine', 'urgent', 'crisis')) DEFAULT 'routine',
  summary TEXT,
  outcome TEXT,
  follow_up_required BOOLEAN DEFAULT FALSE,
  handled_by TEXT REFERENCES staff(id),
  duration_minutes INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Referrals
CREATE TABLE referrals (
  id TEXT PRIMARY KEY,
  client_id TEXT REFERENCES clients(id),
  from_program TEXT REFERENCES programs(id),
  to_program TEXT REFERENCES programs(id),
  urgency TEXT CHECK (urgency IN ('routine', 'urgent', 'crisis')) DEFAULT 'routine',
  reason TEXT,
  notes TEXT,
  status TEXT CHECK (status IN ('pending', 'in-progress', 'completed', 'declined')) DEFAULT 'pending',
  created_by TEXT REFERENCES staff(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Care Journey Events
CREATE TABLE care_journey_events (
  id TEXT PRIMARY KEY,
  client_id TEXT REFERENCES clients(id),
  event_type TEXT CHECK (event_type IN ('call', 'assessment', 'referral', 'admission', 'appointment', 'note')) NOT NULL,
  program_id TEXT REFERENCES programs(id),
  title TEXT NOT NULL,
  performed_by TEXT REFERENCES staff(id),
  note TEXT,
  status TEXT,
  is_current BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security (open for prototypes — lock down for production)
ALTER TABLE programs ENABLE ROW LEVEL SECURITY;
ALTER TABLE staff ENABLE ROW LEVEL SECURITY;
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE diagnoses ENABLE ROW LEVEL SECURITY;
ALTER TABLE medications ENABLE ROW LEVEL SECURITY;
ALTER TABLE allergies ENABLE ROW LEVEL SECURITY;
ALTER TABLE vitals ENABLE ROW LEVEL SECURITY;
ALTER TABLE warm_line_calls ENABLE ROW LEVEL SECURITY;
ALTER TABLE referrals ENABLE ROW LEVEL SECURITY;
ALTER TABLE care_journey_events ENABLE ROW LEVEL SECURITY;

-- Open read/write policies for prototype use (anon key)
CREATE POLICY "Allow all for prototypes" ON programs FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for prototypes" ON staff FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for prototypes" ON clients FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for prototypes" ON diagnoses FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for prototypes" ON medications FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for prototypes" ON allergies FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for prototypes" ON vitals FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for prototypes" ON warm_line_calls FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for prototypes" ON referrals FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for prototypes" ON care_journey_events FOR ALL USING (true) WITH CHECK (true);
