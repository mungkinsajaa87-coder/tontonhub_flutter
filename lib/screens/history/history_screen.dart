import 'package:flutter/material.dart';

import '../../core/formatters.dart';
import '../../models/history_model.dart';
import '../../services/firestore_service.dart';
import '../../widgets/empty_state.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Aktivitas')),
      body: StreamBuilder<List<HistoryModel>>(
        stream: FirestoreService.instance.watchMyHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final items = snapshot.data ?? [];
          if (items.isEmpty) return const EmptyState(message: 'Riwayat aktivitas masih kosong.', icon: Icons.history_toggle_off);
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (_, index) {
              final item = items[index];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.history)),
                  title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text('${item.description}\n${AppFormatters.date(item.createdAt)}'),
                  isThreeLine: true,
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemCount: items.length,
          );
        },
      ),
    );
  }
}
