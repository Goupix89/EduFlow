import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/dashboard_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${user?['firstName'] ?? 'User'}!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  DashboardCard(
                    title: 'Students',
                    icon: Icons.people,
                    onTap: () {
                      // Navigate to students screen
                    },
                  ),
                  DashboardCard(
                    title: 'Attendance',
                    icon: Icons.check_circle,
                    onTap: () {
                      // Navigate to attendance screen
                    },
                  ),
                  DashboardCard(
                    title: 'Grades',
                    icon: Icons.grade,
                    onTap: () {
                      // Navigate to grades screen
                    },
                  ),
                  DashboardCard(
                    title: 'Timetable',
                    icon: Icons.schedule,
                    onTap: () {
                      // Navigate to timetable screen
                    },
                  ),
                  DashboardCard(
                    title: 'Payments',
                    icon: Icons.payment,
                    onTap: () {
                      // Navigate to payments screen
                    },
                  ),
                  DashboardCard(
                    title: 'Reports',
                    icon: Icons.analytics,
                    onTap: () {
                      // Navigate to reports screen
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
