export interface User {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  role: UserRole;
  status: UserStatus;
  tenantId: string;
  schoolId?: string;
  isEmailVerified: boolean;
  lastLoginAt?: Date;
  createdAt: Date;
  updatedAt: Date;
}

export interface Student {
  id: string;
  userId: string;
  studentId: string;
  dateOfBirth: Date;
  gender: string;
  address: string;
  phone?: string;
  emergencyContact?: string;
  enrollmentDate: Date;
  graduationDate?: Date;
  gpa?: number;
  schoolId: string;
  currentClassId?: string;
  isActive: boolean;
}

export interface Teacher {
  id: string;
  userId: string;
  employeeId: string;
  qualification: string;
  specialization?: string;
  hireDate: Date;
  salary?: number;
  schoolId: string;
  isActive: boolean;
}

export interface School {
  id: string;
  name: string;
  type: InstitutionType;
  address: string;
  phone?: string;
  email?: string;
  website?: string;
  tenantId: string;
  isActive: boolean;
  academicYearStart: Date;
  academicYearEnd: Date;
}

export interface Class {
  id: string;
  name: string;
  grade: string;
  section?: string;
  capacity: number;
  schoolId: string;
  teacherId?: string;
  academicYear: string;
  isActive: boolean;
}

export interface Attendance {
  id: string;
  studentId: string;
  classId: string;
  schoolId: string;
  date: Date;
  status: AttendanceStatus;
  checkInTime?: Date;
  checkOutTime?: Date;
  notes?: string;
  markedBy: string;
}

export interface Grade {
  id: string;
  studentId: string;
  subjectId: string;
  teacherId: string;
  classId: string;
  schoolId: string;
  type: GradeType;
  score: number;
  maxScore: number;
  percentage: number;
  grade: string;
  comments?: string;
  date: Date;
  academicYear: string;
  term: string;
  isFinal: boolean;
}

export enum UserRole {
  SUPER_ADMIN = 'SUPER_ADMIN',
  TENANT_ADMIN = 'TENANT_ADMIN',
  SCHOOL_ADMIN = 'SCHOOL_ADMIN',
  TEACHER = 'TEACHER',
  STUDENT = 'STUDENT',
  PARENT = 'PARENT',
}

export enum UserStatus {
  ACTIVE = 'ACTIVE',
  INACTIVE = 'INACTIVE',
  SUSPENDED = 'SUSPENDED',
}

export enum InstitutionType {
  PRIMARY_SCHOOL = 'PRIMARY_SCHOOL',
  SECONDARY_SCHOOL = 'SECONDARY_SCHOOL',
  UNIVERSITY = 'UNIVERSITY',
  TRAINING_CENTER = 'TRAINING_CENTER',
}

export enum AttendanceStatus {
  PRESENT = 'PRESENT',
  ABSENT = 'ABSENT',
  LATE = 'LATE',
  EXCUSED = 'EXCUSED',
}

export enum GradeType {
  ASSIGNMENT = 'ASSIGNMENT',
  QUIZ = 'QUIZ',
  MID_TERM = 'MID_TERM',
  FINAL_EXAM = 'FINAL_EXAM',
  PROJECT = 'PROJECT',
}

export enum PaymentStatus {
  PENDING = 'PENDING',
  COMPLETED = 'COMPLETED',
  FAILED = 'FAILED',
  REFUNDED = 'REFUNDED',
}

export enum SubscriptionPlan {
  BASIC = 'BASIC',
  PROFESSIONAL = 'PROFESSIONAL',
  ENTERPRISE = 'ENTERPRISE',
}