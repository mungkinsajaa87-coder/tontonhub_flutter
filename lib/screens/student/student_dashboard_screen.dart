import 'package:flutter/material.dart';

import '../../models/announcement_model.dart';
import '../../models/video_model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../widgets/app_card.dart';

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TontonHub Subscriber'),
        actions: [IconButton(onPressed: AuthService.instance.logout, icon: const Icon(Icons.logout))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF0B1F3A),
                  Color(0xFF1565C0),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat Datang di TontonHub',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Temukan video terbaru, lihat riwayat tontonan, dan ikuti konten favoritmu.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
            StreamBuilder(
              stream: FirestoreService.instance.watchCurrentUser(),
              builder: (context, snapshot) {
                final user = snapshot.data;
                return AppCard(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: user?.photoUrl.isNotEmpty == true ? NetworkImage(user!.photoUrl) : null,
                        child: user?.photoUrl.isNotEmpty == true ? null : const Icon(Icons.person, size: 32),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Halo, ${user?.name ?? 'Subscriber'}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 4),
                            Text('${user?.idPengguna ?? '-'} • ${user?.minatKonten ?? '-'}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 18),
            LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth > 700;
                return Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: [
                    SizedBox(width: wide ? (constraints.maxWidth - 14) / 2 : constraints.maxWidth, child: _LatestAnnouncements()),
                    SizedBox(width: wide ? (constraints.maxWidth - 14) / 2 : constraints.maxWidth, child: _LatestVideos()),
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

class _LatestAnnouncements extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [ 
          const SizedBox(height: 18),
          const Text('Info Terbaru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          StreamBuilder<List<AnnouncementModel>>(
            stream: FirestoreService.instance.watchAnnouncements(),
            builder: (context, snapshot) {
              final items = (snapshot.data ?? []).take(3).toList();
              if (items.isEmpty) return const Text('Belum ada info.');
              return Column(
                children: items.map((e) => ListTile(contentPadding: EdgeInsets.zero, title: Text(e.title), subtitle: Text(e.category))).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LatestVideos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Rekomendasi Video', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          StreamBuilder<List<VideoModel>>(
            stream: FirestoreService.instance.watchVideos(),
            builder: (context, snapshot) {
              final items = (snapshot.data ?? []).take(3).toList();
              if (items.isEmpty) return const Text('Belum ada video tersedia.');
              return Column(
                children: items.map((e) => ListTile(contentPadding: EdgeInsets.zero, title: Text(e.title), subtitle: Text(e.channelName))).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
