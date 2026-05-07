import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const EduFlowApp(),
    ),
  );
}

class EduFlowApp extends StatelessWidget {
  const EduFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'EduFlow',
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.themeMode,
          home: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return authProvider.isAuthenticated
                  ? const DashboardScreen()
                  : const LoginScreen();
            },
          ),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/dashboard': (context) => const DashboardScreen(),
          },
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
