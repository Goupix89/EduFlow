# EduFlow API Documentation

## Overview

EduFlow provides a comprehensive REST API for managing educational institutions. The API follows RESTful conventions and uses JSON for request/response payloads.

## Base URL

```
https://api.eduflow.com/api/v1
```

## Authentication

All API requests require authentication using JWT tokens. Include the token in the Authorization header:

```
Authorization: Bearer <your-jwt-token>
```

## Common Response Format

### Success Response
```json
{
  "data": {},
  "message": "Operation successful",
  "statusCode": 200
}
```

### Error Response
```json
{
  "error": "Error message",
  "statusCode": 400,
  "timestamp": "2024-01-01T00:00:00.000Z"
}
```

## Endpoints

### Authentication

#### POST /auth/login
Login user and return JWT token.

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "access_token": "jwt-token-here",
  "user": {
    "id": "user-id",
    "email": "user@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "role": "STUDENT"
  }
}
```

#### POST /auth/register
Register a new user.

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123",
  "firstName": "John",
  "lastName": "Doe",
  "role": "STUDENT",
  "tenantId": "tenant-id",
  "schoolId": "school-id"
}
```

### Users

#### GET /users
Get all users (filtered by tenant).

**Query Parameters:**
- `tenantId` (optional): Filter by tenant

**Response:**
```json
[
  {
    "id": "user-id",
    "email": "user@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "role": "STUDENT",
    "status": "ACTIVE",
    "tenantId": "tenant-id",
    "schoolId": "school-id"
  }
]
```

#### GET /users/:id
Get user by ID.

#### PATCH /users/:id
Update user information.

#### DELETE /users/:id
Delete user.

### Students

#### GET /schools/:schoolId/students
Get all students for a school.

**Response:**
```json
[
  {
    "id": "student-id",
    "userId": "user-id",
    "studentId": "STU001",
    "dateOfBirth": "2005-01-01T00:00:00.000Z",
    "gender": "MALE",
    "address": "123 Main St",
    "enrollmentDate": "2023-09-01T00:00:00.000Z",
    "currentClassId": "class-id",
    "isActive": true
  }
]
```

#### POST /schools/:schoolId/students
Create new student.

#### GET /schools/:schoolId/students/:id
Get student by ID.

#### PATCH /schools/:schoolId/students/:id
Update student.

### Attendance

#### GET /attendance
Get attendance records.

**Query Parameters:**
- `studentId` (optional): Filter by student
- `classId` (optional): Filter by class
- `date` (optional): Filter by date
- `schoolId` (optional): Filter by school

**Response:**
```json
[
  {
    "id": "attendance-id",
    "studentId": "student-id",
    "classId": "class-id",
    "schoolId": "school-id",
    "date": "2024-01-01T00:00:00.000Z",
    "status": "PRESENT",
    "checkInTime": "2024-01-01T08:00:00.000Z",
    "checkOutTime": "2024-01-01T15:00:00.000Z",
    "notes": "On time",
    "markedBy": "teacher-id"
  }
]
```

#### POST /attendance
Mark attendance.

**Request Body:**
```json
{
  "studentId": "student-id",
  "classId": "class-id",
  "schoolId": "school-id",
  "date": "2024-01-01T00:00:00.000Z",
  "status": "PRESENT",
  "notes": "Optional notes"
}
```

### Grades

#### GET /grades
Get grade records.

**Query Parameters:**
- `studentId` (optional): Filter by student
- `subjectId` (optional): Filter by subject
- `classId` (optional): Filter by class

**Response:**
```json
[
  {
    "id": "grade-id",
    "studentId": "student-id",
    "subjectId": "subject-id",
    "teacherId": "teacher-id",
    "classId": "class-id",
    "schoolId": "school-id",
    "type": "QUIZ",
    "score": 85,
    "maxScore": 100,
    "percentage": 85,
    "grade": "B+",
    "comments": "Good work",
    "date": "2024-01-01T00:00:00.000Z",
    "academicYear": "2023-2024",
    "term": "Term 1",
    "isFinal": false
  }
]
```

#### POST /grades
Create grade record.

### Timetable

#### GET /timetable
Get timetable entries.

**Query Parameters:**
- `classId` (optional): Filter by class
- `teacherId` (optional): Filter by teacher
- `schoolId` (optional): Filter by school

**Response:**
```json
[
  {
    "id": "timetable-id",
    "classId": "class-id",
    "subjectId": "subject-id",
    "teacherId": "teacher-id",
    "schoolId": "school-id",
    "dayOfWeek": 1,
    "startTime": "09:00",
    "endTime": "10:00",
    "room": "Room 101",
    "academicYear": "2023-2024",
    "isActive": true
  }
]
```

### Financial

#### GET /schools/:schoolId/payments
Get payment records for a school.

**Response:**
```json
[
  {
    "id": "payment-id",
    "studentId": "student-id",
    "schoolId": "school-id",
    "amount": 500.00,
    "currency": "USD",
    "type": "TUITION",
    "description": "Monthly tuition fee",
    "dueDate": "2024-01-01T00:00:00.000Z",
    "paidDate": "2024-01-01T00:00:00.000Z",
    "status": "COMPLETED",
    "paymentMethod": "MPESA",
    "transactionId": "TXN123456"
  }
]
```

#### POST /schools/:schoolId/payments
Create payment record.

## Rate Limiting

API requests are rate limited to 100 requests per minute per user. Exceeding this limit will result in a 429 Too Many Requests response.

## Pagination

List endpoints support pagination using the following query parameters:
- `page`: Page number (default: 1)
- `limit`: Items per page (default: 20, max: 100)

**Response includes:**
```json
{
  "data": [...],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 150,
    "totalPages": 8
  }
}
```

## Error Codes

- `400`: Bad Request - Invalid input data
- `401`: Unauthorized - Invalid or missing authentication
- `403`: Forbidden - Insufficient permissions
- `404`: Not Found - Resource not found
- `409`: Conflict - Resource already exists
- `422`: Unprocessable Entity - Validation failed
- `429`: Too Many Requests - Rate limit exceeded
- `500`: Internal Server Error - Server error

## WebSocket Events

Real-time updates are available via WebSocket at `/socket.io`:

### Events
- `attendance:updated`: Attendance record updated
- `grade:added`: New grade added
- `notification:new`: New notification for user
- `timetable:changed`: Timetable modified

## SDKs and Libraries

- **JavaScript/TypeScript**: Official client library available on npm
- **Python**: PyPI package available
- **Mobile**: Flutter package for mobile apps

For more details, visit the [full API documentation](https://docs.eduflow.com/api).