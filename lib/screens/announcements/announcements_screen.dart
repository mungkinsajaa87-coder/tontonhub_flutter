import 'package:flutter/material.dart';

import '../../core/formatters.dart';
import '../../models/announcement_model.dart';
import '../../services/firestore_service.dart';
import '../../widgets/empty_state.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Info')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Cari info...'),
              onChanged: (value) => setState(() => _query = value.toLowerCase()),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<AnnouncementModel>>(
              stream: FirestoreService.instance.watchAnnouncements(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                final items = (snapshot.data ?? []).where((item) {
                  return item.title.toLowerCase().contains(_query) ||
                      item.content.toLowerCase().contains(_query) ||
                      item.category.toLowerCase().contains(_query);
                }).toList();
                if (items.isEmpty) return const EmptyState(message: 'Info belum tersedia.');
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemBuilder: (context, index) => _AnnouncementTile(item: items[index]),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: items.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AnnouncementTile extends StatelessWidget {
  const _AnnouncementTile({required this.item});
  final AnnouncementModel item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => showDialog(context: context, builder: (_) => _AnnouncementDetail(item: item)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (item.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(item.imageUrl, width: 76, height: 76, fit: BoxFit.cover),
                )
              else
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.campaign, size: 34),
                ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(item.category),
                    const SizedBox(height: 4),
                    Text(AppFormatters.date(item.createdAt), style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnnouncementDetail extends StatelessWidget {
  const _AnnouncementDetail({required this.item});
  final AnnouncementModel item;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(item.title),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(item.imageUrl, fit: BoxFit.cover),
              ),
            if (item.imageUrl.isNotEmpty) const SizedBox(height: 12),
            Text(item.category, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(item.content),
          ],
        ),
      ),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup'))],
    );
  }
}
