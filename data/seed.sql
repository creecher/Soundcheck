-- =============================================
-- SOUNDCHECK — Seed Data
-- Realistic Chorus mock data for prototyping
-- Run AFTER schema.sql in your Supabase SQL editor
-- =============================================

-- Programs
INSERT INTO programs (id, name, description, icon_type, active_client_count) VALUES
  ('prog-warm-line',     'Warm Line',      'Manage incoming calls and crisis interventions', 'phone',    3),
  ('prog-central-intake','Central Intake', 'Initial assessments and client onboarding',      'clipboard', 3),
  ('prog-care-facility', 'Care Facility',  'Residential and outpatient care coordination',   'building',  5);

-- Staff
INSERT INTO staff (id, name, role, title, program_id, email) VALUES
  ('staff-001', 'Mark Thompson',  'care_coordinator', 'Care Coordinator',      'prog-warm-line',      'mark.thompson@chorus.org'),
  ('staff-002', 'Lisa Martinez',  'care_coordinator', 'Crisis Specialist',     'prog-warm-line',      'lisa.martinez@chorus.org'),
  ('staff-003', 'Jane Smith',     'clinician',        'Clinical Intake Lead',  'prog-central-intake', 'jane.smith@chorus.org'),
  ('staff-004', 'Dr. Emily Chen', 'clinician',        'Staff Psychiatrist',    'prog-care-facility',  'emily.chen@chorus.org'),
  ('staff-005', 'David Nguyen',   'care_coordinator', 'Care Coordinator',      'prog-care-facility',  'david.nguyen@chorus.org');

-- Clients
INSERT INTO clients (id, first_name, last_name, preferred_name, pronouns, dob, age, phone_primary, phone_secondary, assigned_clinician, program_id, risk_level, insurance_type, ai_summary) VALUES
  ('CL-001', 'Michael',  'Rodriguez', 'Michael',       'He/Him',  '1985-04-12', 40, '(555) 234-5678', NULL,           'Dr. Emily Chen', 'prog-central-intake', 'high',    'Medi-Cal',        'Michael was referred from Warm Line following a crisis call in early March 2026. He is currently engaged in Central Intake assessment for acute mental health concerns. His care plan includes medication evaluation, individual therapy, and weekly check-ins with his care coordinator.'),
  ('CL-002', 'Maria',    'Rodriguez', 'Maria',         'She/Her', '1990-11-03', 35, '(555) 987-6543', NULL,           'Dr. Emily Chen', 'prog-warm-line',      'high',    'Covered California', 'Maria called the warm line in crisis, reporting concerns about her son. She was escalated to Central Intake for immediate assessment. Follow-up is required to confirm connection with services and ensure safety planning is in place.'),
  ('CL-003', 'Jennifer', 'Lee',       'Jennifer',      'She/Her', '1992-07-22', 33, '(555) 345-6789', NULL,           'Mark Thompson',  'prog-warm-line',      'routine', 'Private Insurance', 'Jennifer called seeking resources for anxiety management and therapy options. She was provided a resource list and a follow-up appointment was scheduled. She is engaged and motivated to pursue outpatient support.'),
  ('CL-004', 'Robert',   'Thompson',  'Robert',        'He/Him',  '1978-02-18', 47, '(555) 876-5432', '(555) 876-0001','Dr. Emily Chen', 'prog-care-facility',  'high',    'Medicare',          'Robert is currently enrolled in the residential dual diagnosis program at Care Facility. He has shown steady progress over the past 60 days. His care team is monitoring medication compliance and preparing a discharge plan for Q2 2026.'),
  ('CL-005', 'Carlos',   'Sanchez',   'Car',           'He/Him',  '1986-02-27', 40, '(555) 012-3456', '(949) 813-5542','Dr. Emily Chen', 'prog-warm-line',      'high',    'Private Insurance', 'Carlos (Car) was seen January 1, 2026 presenting with notable behavioral health concerns including heightened anxiety, low mood, disrupted sleep, and feelings of frustration related to declining physical stamina. Clinical discussion centered on the intersection between his medical condition and psychological well-being. Supportive counseling and recommendations for ongoing behavioral health monitoring were provided.'),
  ('CL-006', 'Linda',    'Garcia',    'Linda',         'She/Her', '1995-09-14', 30, '(555) 654-3210', NULL,           'Jane Smith',     'prog-central-intake', 'routine', 'Medi-Cal',          'Linda was referred by her primary care provider for behavioral health integration services. She is currently completing her intake assessment and has expressed interest in group therapy and case management support.'),
  ('CL-007', 'Sarah',    'Johnson',   'Sarah',         'She/Her', '1988-06-30', 37, '(555) 432-1098', NULL,           'Dr. Emily Chen', 'prog-care-facility',  'routine', 'Covered California', 'Sarah successfully completed her care facility program in early 2024 after a referral from Central Intake. She is currently in aftercare and attending monthly follow-up appointments. Her progress has been stable and she has reconnected with family support.');

-- Diagnoses
INSERT INTO diagnoses (id, client_id, diagnosis_name, icd_code, diagnosed_date, status) VALUES
  -- Michael Rodriguez
  ('dx-001', 'CL-001', 'Major Depressive Disorder, Moderate',          'F32.1',  '2024-01-10', 'current'),
  ('dx-002', 'CL-001', 'Generalized Anxiety Disorder',                 'F41.1',  '2024-01-10', 'current'),
  ('dx-003', 'CL-001', 'Adjustment Disorder with Mixed Emotions',      'F43.23', '2023-05-01', 'past'),
  -- Carlos Sanchez
  ('dx-004', 'CL-005', 'Major Depressive Disorder, Moderate',          'F32.1',  '2025-05-15', 'current'),
  ('dx-005', 'CL-005', 'Generalized Anxiety Disorder',                 'F41.1',  '2025-05-15', 'current'),
  ('dx-006', 'CL-005', 'Type 2 Diabetes Mellitus',                     'E11.9',  '2022-03-01', 'current'),
  ('dx-007', 'CL-005', 'Adjustment Disorder with Depressed Mood',      'F43.21', '2024-11-01', 'past'),
  -- Robert Thompson
  ('dx-008', 'CL-004', 'Substance Use Disorder, Alcohol, Moderate',    'F10.20', '2023-08-15', 'current'),
  ('dx-009', 'CL-004', 'Major Depressive Disorder, Severe',            'F32.2',  '2023-08-15', 'current'),
  ('dx-010', 'CL-004', 'Post-Traumatic Stress Disorder',               'F43.10', '2022-01-01', 'past'),
  -- Jennifer Lee
  ('dx-011', 'CL-003', 'Generalized Anxiety Disorder',                 'F41.1',  '2025-11-20', 'current'),
  -- Maria Rodriguez
  ('dx-012', 'CL-002', 'Acute Stress Reaction',                        'F43.0',  '2026-03-06', 'current');

-- Medications
INSERT INTO medications (id, client_id, medication_name, dosage, condition, status, due_date) VALUES
  ('med-001', 'CL-005', 'Insulin (Glargine)',   '20 units/day', 'Type 2 Diabetes',         'missed',  '2026-03-10'),
  ('med-002', 'CL-005', 'Sertraline',           '50mg daily',   'Major Depressive Disorder','active',  NULL),
  ('med-003', 'CL-005', 'Lorazepam',            '0.5mg PRN',    'Generalized Anxiety',      'active',  NULL),
  ('med-004', 'CL-001', 'Escitalopram',         '10mg daily',   'Major Depressive Disorder','active',  NULL),
  ('med-005', 'CL-001', 'Buspirone',            '15mg twice/day','Generalized Anxiety',     'active',  NULL),
  ('med-006', 'CL-004', 'Naltrexone',           '50mg daily',   'Alcohol Use Disorder',     'active',  NULL),
  ('med-007', 'CL-004', 'Mirtazapine',          '30mg nightly', 'Major Depressive Disorder','active',  NULL);

-- Allergies
INSERT INTO allergies (id, client_id, allergen, severity, note) VALUES
  ('alg-001', 'CL-005', 'Penicillin', 'severe',   'Avoid antibiotics in this class'),
  ('alg-002', 'CL-005', 'Peanuts',    'severe',   'Carries epinephrine auto-injector'),
  ('alg-003', 'CL-001', 'Sulfa drugs','moderate', 'Rash and hives reported'),
  ('alg-004', 'CL-004', 'Latex',      'mild',     'Contact dermatitis only');

-- Vitals
INSERT INTO vitals (id, client_id, type, value, unit, status, recorded_at) VALUES
  ('vit-001', 'CL-005', 'Blood Pressure', '110/78', 'mg/dL',  'normal',   '2026-03-07 09:00:00'),
  ('vit-002', 'CL-005', 'Blood Glucose',  '110/78', 'mg/dL',  'elevated', '2026-03-07 09:00:00'),
  ('vit-003', 'CL-005', 'Heart Rate',     '82',     'bpm',    'normal',   '2026-03-07 09:00:00'),
  ('vit-004', 'CL-001', 'Blood Pressure', '122/80', 'mmHg',   'normal',   '2026-03-08 10:00:00'),
  ('vit-005', 'CL-004', 'Blood Pressure', '138/90', 'mmHg',   'elevated', '2026-03-09 08:30:00'),
  ('vit-006', 'CL-004', 'Weight',         '198',    'lbs',    'normal',   '2026-03-09 08:30:00');

-- Warm Line Calls
INSERT INTO warm_line_calls (id, client_id, caller_name, phone, relationship, priority, summary, outcome, follow_up_required, handled_by, duration_minutes, created_at) VALUES
  ('call-001', 'CL-003', 'Jennifer Lee',  '(555) 345-6789', 'self',   'routine', 'Seeking resources for anxiety management and therapy options',           'Provided resource list and scheduled follow-up',            TRUE,  'staff-001', 18, '2026-03-07 23:30:00'),
  ('call-002', 'CL-002', 'Maria Rodriguez','(555) 987-6543','family', 'crisis',  'Mother reporting son experiencing suicidal ideation',                    'Escalated to Central Intake for immediate assessment',       TRUE,  'staff-001', 45, '2026-03-06 01:15:00'),
  ('call-003', NULL,     'Anonymous',      '(555) 111-2222','other',  'urgent',  'Third party reporting individual in distress at public location',          'Mobile crisis team dispatched',                              FALSE, 'staff-002', 22, '2026-03-07 07:20:00'),
  ('call-004', 'CL-006', 'Linda Garcia',   '(555) 654-3210','self',   'routine', 'Requesting information about group therapy programs and sliding scale fees','Provided program brochure and intake appointment scheduled', TRUE,  'staff-002', 14, '2026-03-05 14:00:00');

-- Referrals
INSERT INTO referrals (id, client_id, from_program, to_program, urgency, reason, notes, status, created_by, created_at, updated_at) VALUES
  ('ref-001', 'CL-001', 'prog-warm-line',     'prog-central-intake', 'urgent',  'Acute mental health crisis requiring assessment',         'Client has history of prior hospitalizations',              'in-progress', 'staff-001', '2026-03-06 01:20:00', '2026-03-08 12:45:00'),
  ('ref-002', 'CL-007', 'prog-central-intake','prog-care-facility',  'routine', 'Dual diagnosis — SUD and depression, residential program', 'Client accepted into residential program',                  'completed',   'staff-003', '2024-01-16 06:30:00', '2024-01-18 02:00:00'),
  ('ref-003', 'CL-006', 'prog-warm-line',     'prog-central-intake', 'routine', 'PCP referral for behavioral health integration',           NULL,                                                        'pending',     'staff-002', '2026-03-05 14:15:00', '2026-03-05 14:15:00'),
  ('ref-004', 'CL-004', 'prog-central-intake','prog-care-facility',  'urgent',  'Residential dual diagnosis program placement',             'Bed confirmed, intake scheduled',                           'completed',   'staff-003', '2024-01-10 10:00:00', '2024-01-20 01:00:00');

-- Care Journey Events
INSERT INTO care_journey_events (id, client_id, event_type, program_id, title, performed_by, note, status, is_current, created_at) VALUES
  -- Carlos Sanchez journey
  ('evt-001', 'CL-005', 'call',        'prog-warm-line',      'Initial contact via warm line',                        'staff-001', NULL,                                     NULL,        FALSE, '2024-01-15 02:30:00'),
  ('evt-002', 'CL-005', 'assessment',  'prog-central-intake', 'Initial assessment completed',                         'staff-003', NULL,                                     NULL,        FALSE, '2024-01-16 06:00:00'),
  ('evt-003', 'CL-005', 'referral',    'prog-central-intake', 'Referral to care facility submitted',                  'staff-003', NULL,                                     NULL,        FALSE, '2024-01-16 06:30:00'),
  ('evt-004', 'CL-005', 'referral',    'prog-central-intake', 'Referral to care facility — Dual diagnosis — SUD and depression', 'staff-003', 'Client accepted into residential program', 'completed', FALSE, '2024-01-16 06:30:00'),
  ('evt-005', 'CL-005', 'admission',   'prog-care-facility',  'Admitted to dual diagnosis program',                   'staff-004', NULL,                                     NULL,        FALSE, '2024-01-20 01:00:00'),
  ('evt-006', 'CL-005', 'appointment', 'prog-care-facility',  'Follow-up assessment — 60 days progress review',       'staff-004', NULL,                                     'current',   TRUE,  '2026-03-07 06:00:00'),
  -- Michael Rodriguez journey
  ('evt-007', 'CL-001', 'call',        'prog-warm-line',      'Crisis call received — acute distress reported',       'staff-001', NULL,                                     NULL,        FALSE, '2026-03-06 01:00:00'),
  ('evt-008', 'CL-001', 'referral',    'prog-warm-line',      'Escalated referral to Central Intake',                 'staff-001', 'Urgent — prior hospitalization history', 'in-progress',FALSE,'2026-03-06 01:20:00'),
  ('evt-009', 'CL-001', 'assessment',  'prog-central-intake', 'Central Intake assessment scheduled',                  'staff-003', NULL,                                     'upcoming',  TRUE,  '2026-03-08 12:45:00'),
  -- Sarah Johnson journey
  ('evt-010', 'CL-007', 'call',        'prog-warm-line',      'Initial contact via warm line',                        'staff-001', NULL,                                     NULL,        FALSE, '2024-01-15 02:30:00'),
  ('evt-011', 'CL-007', 'assessment',  'prog-central-intake', 'Intake assessment completed',                          'staff-003', NULL,                                     NULL,        FALSE, '2024-01-16 06:00:00'),
  ('evt-012', 'CL-007', 'referral',    'prog-central-intake', 'Referral to Care Facility completed',                  'staff-003', 'Client accepted into residential program','completed', FALSE,'2024-01-18 02:00:00'),
  ('evt-013', 'CL-007', 'appointment', 'prog-care-facility',  'Monthly aftercare follow-up',                          'staff-004', NULL,                                     'current',   TRUE,  '2026-03-01 10:00:00');
