/*
# SwasthyaSaathi - Complete Database Schema

1. Overview
- Multi-user healthcare management platform for Indian families.
- Each user manages their own health data and can add family members.
- All tables are owner-scoped with RLS policies.

2. New Tables
- `profiles` — extends auth.users with full name, phone, dob, blood group, etc.
- `family_members` — family members managed by a user (separate health profiles)
- `medical_profiles` — detailed health info per person (user or family member)
- `medical_records` — uploaded documents (prescriptions, lab reports, etc.)
- `prescriptions` — scanned/entered prescription records
- `medicines` — medicine entries with dosage and schedule
- `medicine_intakes` — tracking of taken/missed/skipped medicine doses
- `doctors` — saved doctor contacts
- `appointments` — doctor appointments with reminders
- `health_timeline_events` — chronological health events (auto + manual)
- `government_schemes` — curated government health schemes (admin-managed, readable by all)
- `notifications` — in-app notification center
- `emergency_contacts` — emergency contact persons
- `food_guidance` — curated food & lifestyle guidance (readable by all)

3. Security
- RLS enabled on ALL tables.
- Owner-scoped CRUD for user data tables (profiles, family_members, medical_records, etc.)
- government_schemes and food_guidance are readable by all authenticated users (admin-managed).
- All owner columns default to auth.uid().
*/

-- PROFILES TABLE
CREATE TABLE IF NOT EXISTS profiles (
  id uuid PRIMARY KEY DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name text NOT NULL DEFAULT '',
  phone text,
  dob date,
  gender text DEFAULT 'prefer_not_to_say',
  blood_group text,
  email text,
  avatar_url text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_own_profile" ON profiles;
CREATE POLICY "select_own_profile" ON profiles FOR SELECT
  TO authenticated USING (auth.uid() = id);

DROP POLICY IF EXISTS "insert_own_profile" ON profiles;
CREATE POLICY "insert_own_profile" ON profiles FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = id);

DROP POLICY IF EXISTS "update_own_profile" ON profiles;
CREATE POLICY "update_own_profile" ON profiles FOR UPDATE
  TO authenticated USING (auth.uid() = id) WITH CHECK (auth.uid() = id);

DROP POLICY IF EXISTS "delete_own_profile" ON profiles;
CREATE POLICY "delete_own_profile" ON profiles FOR DELETE
  TO authenticated USING (auth.uid() = id);

-- FAMILY MEMBERS TABLE
CREATE TABLE IF NOT EXISTS family_members (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  name text NOT NULL,
  relationship text,
  dob date,
  gender text DEFAULT 'prefer_not_to_say',
  blood_group text,
  phone text,
  avatar_url text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE family_members ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_own_family_members" ON family_members;
CREATE POLICY "select_own_family_members" ON family_members FOR SELECT
  TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "insert_own_family_members" ON family_members;
CREATE POLICY "insert_own_family_members" ON family_members FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "update_own_family_members" ON family_members;
CREATE POLICY "update_own_family_members" ON family_members FOR UPDATE
  TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "delete_own_family_members" ON family_members;
CREATE POLICY "delete_own_family_members" ON family_members FOR DELETE
  TO authenticated USING (auth.uid() = user_id);

-- MEDICAL PROFILES TABLE (for user or family member)
CREATE TABLE IF NOT EXISTS medical_profiles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  family_member_id uuid REFERENCES family_members(id) ON DELETE CASCADE,
  owner_type text DEFAULT 'self',
  allergies text,
  existing_conditions text,
  previous_surgeries text,
  current_medicines text,
  important_notes text,
  height text,
  weight text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE medical_profiles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_own_medical_profiles" ON medical_profiles;
CREATE POLICY "select_own_medical_profiles" ON medical_profiles FOR SELECT
  TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "insert_own_medical_profiles" ON medical_profiles;
CREATE POLICY "insert_own_medical_profiles" ON medical_profiles FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "update_own_medical_profiles" ON medical_profiles;
CREATE POLICY "update_own_medical_profiles" ON medical_profiles FOR UPDATE
  TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "delete_own_medical_profiles" ON medical_profiles;
CREATE POLICY "delete_own_medical_profiles" ON medical_profiles FOR DELETE
  TO authenticated USING (auth.uid() = user_id);

-- MEDICAL RECORDS TABLE
CREATE TABLE IF NOT EXISTS medical_records (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  family_member_id uuid REFERENCES family_members(id) ON DELETE CASCADE,
  owner_type text DEFAULT 'self',
  title text NOT NULL,
  category text NOT NULL DEFAULT 'other',
  record_date date,
  doctor_name text,
  hospital text,
  notes text,
  file_url text,
  file_type text,
  file_name text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE medical_records ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_own_medical_records" ON medical_records;
CREATE POLICY "select_own_medical_records" ON medical_records FOR SELECT
  TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "insert_own_medical_records" ON medical_records;
CREATE POLICY "insert_own_medical_records" ON medical_records FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "update_own_medical_records" ON medical_records;
CREATE POLICY "update_own_medical_records" ON medical_records FOR UPDATE
  TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "delete_own_medical_records" ON medical_records;
CREATE POLICY "delete_own_medical_records" ON medical_records FOR DELETE
  TO authenticated USING (auth.uid() = user_id);

-- PRESCRIPTIONS TABLE
CREATE TABLE IF NOT EXISTS prescriptions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  family_member_id uuid REFERENCES family_members(id) ON DELETE CASCADE,
  owner_type text DEFAULT 'self',
  doctor_name text,
  hospital text,
  prescription_date date,
  patient_name text,
  instructions text,
  follow_up_date date,
  file_url text,
  ocr_data jsonb,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE prescriptions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_own_prescriptions" ON prescriptions;
CREATE POLICY "select_own_prescriptions" ON prescriptions FOR SELECT
  TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "insert_own_prescriptions" ON prescriptions;
CREATE POLICY "insert_own_prescriptions" ON prescriptions FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "update_own_prescriptions" ON prescriptions;
CREATE POLICY "update_own_prescriptions" ON prescriptions FOR UPDATE
  TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "delete_own_prescriptions" ON prescriptions;
CREATE POLICY "delete_own_prescriptions" ON prescriptions FOR DELETE
  TO authenticated USING (auth.uid() = user_id);

-- MEDICINES TABLE
CREATE TABLE IF NOT EXISTS medicines (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  family_member_id uuid REFERENCES family_members(id) ON DELETE CASCADE,
  owner_type text DEFAULT 'self',
  name text NOT NULL,
  dosage text,
  schedule_morning boolean DEFAULT false,
  schedule_afternoon boolean DEFAULT false,
  schedule_evening boolean DEFAULT false,
  schedule_night boolean DEFAULT false,
  food_instruction text DEFAULT 'after_food',
  start_date date,
  end_date date,
  stock integer DEFAULT 0,
  low_stock_threshold integer DEFAULT 5,
  notes text,
  active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE medicines ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_own_medicines" ON medicines;
CREATE POLICY "select_own_medicines" ON medicines FOR SELECT
  TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "insert_own_medicines" ON medicines;
CREATE POLICY "insert_own_medicines" ON medicines FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "update_own_medicines" ON medicines;
CREATE POLICY "update_own_medicines" ON medicines FOR UPDATE
  TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "delete_own_medicines" ON medicines;
CREATE POLICY "delete_own_medicines" ON medicines FOR DELETE
  TO authenticated USING (auth.uid() = user_id);

-- MEDICINE INTAKES TABLE
CREATE TABLE IF NOT EXISTS medicine_intakes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  medicine_id uuid NOT NULL REFERENCES medicines(id) ON DELETE CASCADE,
  intake_date date NOT NULL,
  time_slot text NOT NULL,
  status text DEFAULT 'pending',
  taken_at timestamptz,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE medicine_intakes ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_own_medicine_intakes" ON medicine_intakes;
CREATE POLICY "select_own_medicine_intakes" ON medicine_intakes FOR SELECT
  TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "insert_own_medicine_intakes" ON medicine_intakes;
CREATE POLICY "insert_own_medicine_intakes" ON medicine_intakes FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "update_own_medicine_intakes" ON medicine_intakes;
CREATE POLICY "update_own_medicine_intakes" ON medicine_intakes FOR UPDATE
  TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "delete_own_medicine_intakes" ON medicine_intakes;
CREATE POLICY "delete_own_medicine_intakes" ON medicine_intakes FOR DELETE
  TO authenticated USING (auth.uid() = user_id);

-- DOCTORS TABLE
CREATE TABLE IF NOT EXISTS doctors (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  name text NOT NULL,
  specialization text,
  clinic_hospital text,
  phone text,
  address text,
  last_visit date,
  next_visit date,
  notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE doctors ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_own_doctors" ON doctors;
CREATE POLICY "select_own_doctors" ON doctors FOR SELECT
  TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "insert_own_doctors" ON doctors;
CREATE POLICY "insert_own_doctors" ON doctors FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "update_own_doctors" ON doctors;
CREATE POLICY "update_own_doctors" ON doctors FOR UPDATE
  TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "delete_own_doctors" ON doctors;
CREATE POLICY "delete_own_doctors" ON doctors FOR DELETE
  TO authenticated USING (auth.uid() = user_id);

-- APPOINTMENTS TABLE
CREATE TABLE IF NOT EXISTS appointments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  family_member_id uuid REFERENCES family_members(id) ON DELETE CASCADE,
  owner_type text DEFAULT 'self',
  doctor_id uuid REFERENCES doctors(id) ON DELETE SET NULL,
  doctor_name text,
  hospital text,
  appointment_date date NOT NULL,
  appointment_time text,
  reason text,
  notes text,
  follow_up_date date,
  status text DEFAULT 'upcoming',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_own_appointments" ON appointments;
CREATE POLICY "select_own_appointments" ON appointments FOR SELECT
  TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "insert_own_appointments" ON appointments;
CREATE POLICY "insert_own_appointments" ON appointments FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "update_own_appointments" ON appointments;
CREATE POLICY "update_own_appointments" ON appointments FOR UPDATE
  TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "delete_own_appointments" ON appointments;
CREATE POLICY "delete_own_appointments" ON appointments FOR DELETE
  TO authenticated USING (auth.uid() = user_id);

-- HEALTH TIMELINE EVENTS TABLE
CREATE TABLE IF NOT EXISTS health_timeline_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  family_member_id uuid REFERENCES family_members(id) ON DELETE CASCADE,
  owner_type text DEFAULT 'self',
  event_type text NOT NULL,
  title text NOT NULL,
  description text,
  event_date date NOT NULL,
  metadata jsonb,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE health_timeline_events ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_own_timeline_events" ON health_timeline_events;
CREATE POLICY "select_own_timeline_events" ON health_timeline_events FOR SELECT
  TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "insert_own_timeline_events" ON health_timeline_events;
CREATE POLICY "insert_own_timeline_events" ON health_timeline_events FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "update_own_timeline_events" ON health_timeline_events;
CREATE POLICY "update_own_timeline_events" ON health_timeline_events FOR UPDATE
  TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "delete_own_timeline_events" ON health_timeline_events;
CREATE POLICY "delete_own_timeline_events" ON health_timeline_events FOR DELETE
  TO authenticated USING (auth.uid() = user_id);

-- GOVERNMENT SCHEMES TABLE (admin-managed, readable by all authenticated users)
CREATE TABLE IF NOT EXISTS government_schemes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text,
  category text,
  eligibility text,
  required_documents text,
  application_process text,
  official_website text,
  state text DEFAULT 'all',
  is_central boolean DEFAULT true,
  important_dates text,
  source text,
  last_updated date,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE government_schemes ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "read_government_schemes" ON government_schemes;
CREATE POLICY "read_government_schemes" ON government_schemes FOR SELECT
  TO authenticated USING (true);

DROP POLICY IF EXISTS "insert_government_schemes" ON government_schemes;
CREATE POLICY "insert_government_schemes" ON government_schemes FOR INSERT
  TO authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "update_government_schemes" ON government_schemes;
CREATE POLICY "update_government_schemes" ON government_schemes FOR UPDATE
  TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "delete_government_schemes" ON government_schemes;
CREATE POLICY "delete_government_schemes" ON government_schemes FOR DELETE
  TO authenticated USING (true);

-- NOTIFICATIONS TABLE
CREATE TABLE IF NOT EXISTS notifications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  type text NOT NULL,
  title text NOT NULL,
  message text,
  is_read boolean DEFAULT false,
  action_url text,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_own_notifications" ON notifications;
CREATE POLICY "select_own_notifications" ON notifications FOR SELECT
  TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "insert_own_notifications" ON notifications;
CREATE POLICY "insert_own_notifications" ON notifications FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "update_own_notifications" ON notifications;
CREATE POLICY "update_own_notifications" ON notifications FOR UPDATE
  TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "delete_own_notifications" ON notifications;
CREATE POLICY "delete_own_notifications" ON notifications FOR DELETE
  TO authenticated USING (auth.uid() = user_id);

-- EMERGENCY CONTACTS TABLE
CREATE TABLE IF NOT EXISTS emergency_contacts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  name text NOT NULL,
  relationship text,
  phone text NOT NULL,
  is_primary boolean DEFAULT false,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE emergency_contacts ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_own_emergency_contacts" ON emergency_contacts;
CREATE POLICY "select_own_emergency_contacts" ON emergency_contacts FOR SELECT
  TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "insert_own_emergency_contacts" ON emergency_contacts;
CREATE POLICY "insert_own_emergency_contacts" ON emergency_contacts FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "update_own_emergency_contacts" ON emergency_contacts;
CREATE POLICY "update_own_emergency_contacts" ON emergency_contacts FOR UPDATE
  TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "delete_own_emergency_contacts" ON emergency_contacts;
CREATE POLICY "delete_own_emergency_contacts" ON emergency_contacts FOR DELETE
  TO authenticated USING (auth.uid() = user_id);

-- FOOD GUIDANCE TABLE (admin-managed, readable by all authenticated users)
CREATE TABLE IF NOT EXISTS food_guidance (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  category text NOT NULL,
  title text NOT NULL,
  description text,
  icon text,
  condition_tags text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE food_guidance ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "read_food_guidance" ON food_guidance;
CREATE POLICY "read_food_guidance" ON food_guidance FOR SELECT
  TO authenticated USING (true);

DROP POLICY IF EXISTS "insert_food_guidance" ON food_guidance;
CREATE POLICY "insert_food_guidance" ON food_guidance FOR INSERT
  TO authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "update_food_guidance" ON food_guidance;
CREATE POLICY "update_food_guidance" ON food_guidance FOR UPDATE
  TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "delete_food_guidance" ON food_guidance;
CREATE POLICY "delete_food_guidance" ON food_guidance FOR DELETE
  TO authenticated USING (true);

-- INDEXES
CREATE INDEX IF NOT EXISTS idx_family_members_user ON family_members(user_id);
CREATE INDEX IF NOT EXISTS idx_medical_records_user ON medical_records(user_id);
CREATE INDEX IF NOT EXISTS idx_medical_records_category ON medical_records(category);
CREATE INDEX IF NOT EXISTS idx_prescriptions_user ON prescriptions(user_id);
CREATE INDEX IF NOT EXISTS idx_medicines_user ON medicines(user_id);
CREATE INDEX IF NOT EXISTS idx_medicines_active ON medicines(active);
CREATE INDEX IF NOT EXISTS idx_medicine_intakes_user ON medicine_intakes(user_id);
CREATE INDEX IF NOT EXISTS idx_medicine_intakes_date ON medicine_intakes(intake_date);
CREATE INDEX IF NOT EXISTS idx_doctors_user ON doctors(user_id);
CREATE INDEX IF NOT EXISTS idx_appointments_user ON appointments(user_id);
CREATE INDEX IF NOT EXISTS idx_appointments_date ON appointments(appointment_date);
CREATE INDEX IF NOT EXISTS idx_timeline_events_user ON health_timeline_events(user_id);
CREATE INDEX IF NOT EXISTS idx_timeline_events_date ON health_timeline_events(event_date);
CREATE INDEX IF NOT EXISTS idx_notifications_user ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_emergency_contacts_user ON emergency_contacts(user_id);
CREATE INDEX IF NOT EXISTS idx_government_schemes_state ON government_schemes(state);
CREATE INDEX IF NOT EXISTS idx_food_guidance_category ON food_guidance(category);
