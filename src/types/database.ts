export type OwnerType = 'self' | 'family';

export type BloodGroup = 'A+' | 'A-' | 'B+' | 'B-' | 'AB+' | 'AB-' | 'O+' | 'O-' | '';

export type Gender = 'male' | 'female' | 'other' | 'prefer_not_to_say';

export type RecordCategory =
  | 'prescription'
  | 'lab_report'
  | 'blood_test'
  | 'scan_report'
  | 'discharge_summary'
  | 'vaccination'
  | 'medical_bill'
  | 'doctor_note'
  | 'other';

export type FoodInstruction = 'before_food' | 'after_food' | 'with_food' | 'empty_stomach';

export type TimeSlot = 'morning' | 'afternoon' | 'evening' | 'night';

export type IntakeStatus = 'pending' | 'taken' | 'skipped' | 'remind_later';

export type AppointmentStatus = 'upcoming' | 'completed' | 'cancelled';

export type TimelineEventType =
  | 'doctor_visit'
  | 'prescription'
  | 'lab_report'
  | 'medicine'
  | 'vaccination'
  | 'hospitalization'
  | 'appointment'
  | 'document';

export type NotificationType =
  | 'medicine_reminder'
  | 'appointment_reminder'
  | 'follow_up_reminder'
  | 'low_stock'
  | 'health_task'
  | 'document_reminder'
  | 'scheme_update';

export interface Profile {
  id: string;
  full_name: string;
  phone: string | null;
  dob: string | null;
  gender: Gender;
  blood_group: string | null;
  email: string | null;
  avatar_url: string | null;
  created_at: string;
  updated_at: string;
}

export interface FamilyMember {
  id: string;
  user_id: string;
  name: string;
  relationship: string | null;
  dob: string | null;
  gender: Gender;
  blood_group: string | null;
  phone: string | null;
  avatar_url: string | null;
  created_at: string;
  updated_at: string;
}

export interface MedicalProfile {
  id: string;
  user_id: string;
  family_member_id: string | null;
  owner_type: OwnerType;
  allergies: string | null;
  existing_conditions: string | null;
  previous_surgeries: string | null;
  current_medicines: string | null;
  important_notes: string | null;
  height: string | null;
  weight: string | null;
  created_at: string;
  updated_at: string;
}

export interface MedicalRecord {
  id: string;
  user_id: string;
  family_member_id: string | null;
  owner_type: OwnerType;
  title: string;
  category: RecordCategory;
  record_date: string | null;
  doctor_name: string | null;
  hospital: string | null;
  notes: string | null;
  file_url: string | null;
  file_type: string | null;
  file_name: string | null;
  created_at: string;
  updated_at: string;
}

export interface Prescription {
  id: string;
  user_id: string;
  family_member_id: string | null;
  owner_type: OwnerType;
  doctor_name: string | null;
  hospital: string | null;
  prescription_date: string | null;
  patient_name: string | null;
  instructions: string | null;
  follow_up_date: string | null;
  file_url: string | null;
  ocr_data: Record<string, unknown> | null;
  created_at: string;
  updated_at: string;
}

export interface Medicine {
  id: string;
  user_id: string;
  family_member_id: string | null;
  owner_type: OwnerType;
  name: string;
  dosage: string | null;
  schedule_morning: boolean;
  schedule_afternoon: boolean;
  schedule_evening: boolean;
  schedule_night: boolean;
  food_instruction: FoodInstruction;
  start_date: string | null;
  end_date: string | null;
  stock: number;
  low_stock_threshold: number;
  notes: string | null;
  active: boolean;
  created_at: string;
  updated_at: string;
}

export interface MedicineIntake {
  id: string;
  user_id: string;
  medicine_id: string;
  intake_date: string;
  time_slot: TimeSlot;
  status: IntakeStatus;
  taken_at: string | null;
  created_at: string;
}

export interface Doctor {
  id: string;
  user_id: string;
  name: string;
  specialization: string | null;
  clinic_hospital: string | null;
  phone: string | null;
  address: string | null;
  last_visit: string | null;
  next_visit: string | null;
  notes: string | null;
  created_at: string;
  updated_at: string;
}

export interface Appointment {
  id: string;
  user_id: string;
  family_member_id: string | null;
  owner_type: OwnerType;
  doctor_id: string | null;
  doctor_name: string | null;
  hospital: string | null;
  appointment_date: string;
  appointment_time: string | null;
  reason: string | null;
  notes: string | null;
  follow_up_date: string | null;
  status: AppointmentStatus;
  created_at: string;
  updated_at: string;
}

export interface HealthTimelineEvent {
  id: string;
  user_id: string;
  family_member_id: string | null;
  owner_type: OwnerType;
  event_type: TimelineEventType;
  title: string;
  description: string | null;
  event_date: string;
  metadata: Record<string, unknown> | null;
  created_at: string;
}

export interface GovernmentScheme {
  id: string;
  name: string;
  description: string | null;
  category: string | null;
  eligibility: string | null;
  required_documents: string | null;
  application_process: string | null;
  official_website: string | null;
  state: string;
  is_central: boolean;
  important_dates: string | null;
  source: string | null;
  last_updated: string | null;
  created_at: string;
  updated_at: string;
}

export interface NotificationItem {
  id: string;
  user_id: string;
  type: NotificationType;
  title: string;
  message: string | null;
  is_read: boolean;
  action_url: string | null;
  created_at: string;
}

export interface EmergencyContact {
  id: string;
  user_id: string;
  name: string;
  relationship: string | null;
  phone: string;
  is_primary: boolean;
  created_at: string;
  updated_at: string;
}

export interface FoodGuidance {
  id: string;
  category: string;
  title: string;
  description: string | null;
  icon: string | null;
  condition_tags: string | null;
  created_at: string;
  updated_at: string;
}
