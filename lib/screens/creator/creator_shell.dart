import 'package:flutter/material.dart';

import '../profile/profile_screen.dart';
import 'creator_announcements_screen.dart';
import 'creator_dashboard_screen.dart';
import 'creator_videos_screen.dart';
import 'creator_registrations_screen.dart';

class CreatorShell extends StatefulWidget {
  const CreatorShell({super.key});

  @override
  State<CreatorShell> createState() => _CreatorShellState();
}

class _CreatorShellState extends State<CreatorShell> {
  int _index = 0;

  final _pages = const [
    CreatorDashboardScreen(),
    CreatorAnnouncementsScreen(),
    CreatorVideosScreen(),
    CreatorRegistrationsScreen(),
    ProfileScreen(),
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
                NavigationRailDestination(icon: Icon(Icons.fact_check_outlined), selectedIcon: Icon(Icons.fact_check), label: Text('Subscribe')),
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
              destinations: const [
                NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
                NavigationDestination(icon: Icon(Icons.campaign_outlined), selectedIcon: Icon(Icons.campaign), label: 'Info'),
                NavigationDestination(icon: Icon(Icons.ondemand_video_outlined), selectedIcon: Icon(Icons.ondemand_video), label: 'Video'),
                NavigationDestination(icon: Icon(Icons.fact_check_outlined), selectedIcon: Icon(Icons.fact_check), label: 'Subscribe'),
                NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
              ],
            ),
    );
  }
}
