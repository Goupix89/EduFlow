import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { ThrottlerModule } from '@nestjs/throttler';
import { PrismaModule } from './common/prisma/prisma.module';
import { AuthModule } from './modules/auth/auth.module';
import { UsersModule } from './modules/users/users.module';
import { TenantsModule } from './modules/tenants/tenants.module';
import { SchoolsModule } from './modules/schools/schools.module';
import { StudentsModule } from './modules/students/students.module';
import { TeachersModule } from './modules/teachers/teachers.module';
import { AttendanceModule } from './modules/attendance/attendance.module';
import { GradesModule } from './modules/grades/grades.module';
import { TimetableModule } from './modules/timetable/timetable.module';
import { FinancialModule } from './modules/financial/financial.module';
import { NotificationsModule } from './modules/notifications/notifications.module';
import { AiModule } from './modules/ai/ai.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: ['.env.local', '.env'],
    }),
    ThrottlerModule.forRoot({
      ttl: 60,
      limit: 100,
    }),
    PrismaModule,
    AuthModule,
    UsersModule,
    TenantsModule,
    SchoolsModule,
    StudentsModule,
    TeachersModule,
    AttendanceModule,
    GradesModule,
    TimetableModule,
    FinancialModule,
    NotificationsModule,
    AiModule,
  ],
})
export class AppModule {}