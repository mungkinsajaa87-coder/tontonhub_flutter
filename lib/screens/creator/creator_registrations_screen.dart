import 'package:flutter/material.dart';

import '../../core/formatters.dart';
import '../../models/registration_model.dart';
import '../../services/firestore_service.dart';
import '../../widgets/empty_state.dart';

class CreatorRegistrationsScreen extends StatelessWidget {
  const CreatorRegistrationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Subscribe')),
      body: StreamBuilder<List<RegistrationModel>>(
        stream: FirestoreService.instance.watchAllRegistrations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final items = snapshot.data ?? [];
          if (items.isEmpty) return const EmptyState(message: 'Belum ada subscriber.', icon: Icons.fact_check_outlined);
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (_, index) {
              final item = items[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.videoTitle, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('Subscriber: ${item.userName}'),
                      Text('Status: ${item.status}'),
                      Text('Tanggal: ${AppFormatters.date(item.registeredAt)}'),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          FilledButton.tonalIcon(
                            onPressed: () => FirestoreService.instance.updateRegistrationStatus(item, 'active'),
                            icon: const Icon(Icons.check),
                            label: const Text('Aktifkan'),
                          ),
                          FilledButton.tonalIcon(
                            onPressed: () => FirestoreService.instance.updateRegistrationStatus(item, 'inactive'),
                            icon: const Icon(Icons.close),
                            label: const Text('Nonaktifkan'),
                          ),
                        ],
                      ),
                    ],
                  ),
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
