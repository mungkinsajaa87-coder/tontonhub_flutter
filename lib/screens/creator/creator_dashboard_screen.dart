import 'package:flutter/material.dart';

import '../../models/announcement_model.dart';
import '../../models/video_model.dart';
import '../../models/registration_model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../widgets/app_card.dart';

class CreatorDashboardScreen extends StatelessWidget {
  const CreatorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Creator'),
        actions: [IconButton(onPressed: AuthService.instance.logout, icon: const Icon(Icons.logout))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Panel Pengelolaan TontonHub', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
            const SizedBox(height: 18),
            LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = constraints.maxWidth > 800 ? (constraints.maxWidth - 28) / 3 : constraints.maxWidth;
                return Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: [
                    SizedBox(width: itemWidth, child: _CountCard<AnnouncementModel>(title: 'Info', icon: Icons.campaign, stream: FirestoreService.instance.watchAnnouncements())),
                    SizedBox(width: itemWidth, child: _CountCard<VideoModel>(title: 'Video', icon: Icons.ondemand_video, stream: FirestoreService.instance.watchVideos())),
                    SizedBox(width: itemWidth, child: _CountCard<RegistrationModel>(title: 'Subscribe', icon: Icons.fact_check, stream: FirestoreService.instance.watchAllRegistrations())),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CountCard<T> extends StatelessWidget {
  const _CountCard({required this.title, required this.icon, required this.stream});
  final String title;
  final IconData icon;
  final Stream<List<T>> stream;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: StreamBuilder<List<T>>(
        stream: stream,
        builder: (context, snapshot) {
          final count = snapshot.data?.length ?? 0;
          return Row(
            children: [
              CircleAvatar(radius: 26, child: Icon(icon)),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$count', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                  Text(title),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
