import 'package:flutter/material.dart';

import '../announcements/announcements_screen.dart';
import '../videos/videos_screen.dart';
import '../history/history_screen.dart';
import '../profile/profile_screen.dart';
import 'student_dashboard_screen.dart';

class StudentShell extends StatefulWidget {
  const StudentShell({super.key});

  @override
  State<StudentShell> createState() => _StudentShellState();
}

class _StudentShellState extends State<StudentShell> {
  int _index = 0;

  final _pages = const [
    StudentDashboardScreen(),
    AnnouncementsScreen(),
    VideosScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  final _destinations = const [
    NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
    NavigationDestination(icon: Icon(Icons.campaign_outlined), selectedIcon: Icon(Icons.campaign), label: 'Info'),
    NavigationDestination(icon: Icon(Icons.ondemand_video_outlined), selectedIcon: Icon(Icons.ondemand_video), label: 'Video'),
    NavigationDestination(icon: Icon(Icons.history_outlined), selectedIcon: Icon(Icons.history), label: 'Riwayat'),
    NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;
    return Scaffold(
      body: Row(
        children: [
          if (isWide)
            NavigationRail(
              selectedIndex: _index,
              onDestinationSelected: (value) => setState(() => _index = value),
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: Text('Dashboard')),
                NavigationRailDestination(icon: Icon(Icons.campaign_outlined), selectedIcon: Icon(Icons.campaign), label: Text('Info')),
                NavigationRailDestination(icon: Icon(Icons.ondemand_video_outlined), selectedIcon: Icon(Icons.ondemand_video), label: Text('Video')),
                NavigationRailDestination(icon: Icon(Icons.history_outlined), selectedIcon: Icon(Icons.history), label: Text('Riwayat')),
                NavigationRailDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: Text('Profil')),
              ],
            ),
          Expanded(child: _pages[_index]),
        ],
      ),
      bottomNavigationBar: isWide
          ? null
          : NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (value) => setState(() => _index = value),
              destinations: _destinations,
            ),
    );
  }
}
