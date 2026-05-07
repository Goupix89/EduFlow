class Constants {
  static const String appName = 'EduFlow';
  static const String apiBaseUrl = 'https://api.eduflow.com/api/v1';

  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String studentsEndpoint = '/students';
  static const String attendanceEndpoint = '/attendance';
  static const String gradesEndpoint = '/grades';
  static const String timetableEndpoint = '/timetable';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';

  // Colors
  static const int primaryColor = 0xFF3B82F6;
  static const int secondaryColor = 0xFF6366F1;
  static const int accentColor = 0xFF10B981;

  // Dimensions
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;
  static const double defaultElevation = 4.0;

  // Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
}
