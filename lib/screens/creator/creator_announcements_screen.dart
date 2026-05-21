import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../models/announcement_model.dart';
import '../../services/firestore_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/empty_state.dart';

class CreatorAnnouncementsScreen extends StatefulWidget {
  const CreatorAnnouncementsScreen({super.key});

  @override
  State<CreatorAnnouncementsScreen> createState() => _CreatorAnnouncementsScreenState();
}

class _CreatorAnnouncementsScreenState extends State<CreatorAnnouncementsScreen> {
  final _title = TextEditingController();
  final _content = TextEditingController();
  String _category = 'Umum';
  String _imageUrl = '';
  bool _loading = false;

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  Future<void> _upload() async {
    setState(() => _loading = true);
    try {
      final url = await StorageService.instance.pickAndUploadImage(folder: 'announcement_images');
      if (url != null) setState(() => _imageUrl = url);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    if (_title.text.trim().isEmpty || _content.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Judul dan isi wajib diisi.')));
      return;
    }
    setState(() => _loading = true);
    try {
      await FirestoreService.instance.addAnnouncement(
        title: _title.text,
        content: _content.text,
        category: _category,
        imageUrl: _imageUrl,
      );
      _title.clear();
      _content.clear();
      setState(() => _imageUrl = '');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Info berhasil ditambahkan.')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Info')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;
          return wide
              ? Row(children: [SizedBox(width: 420, child: _FormPanel()), Expanded(child: _ListPanel())])
              : Column(children: [Expanded(child: _ListPanel()), _BottomAddButton(onTap: () => _showForm(context))]);
        },
      ),
    );
  }

  Widget _FormPanel() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tambah Info', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 14),
              TextField(controller: _title, decoration: const InputDecoration(labelText: 'Judul')),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Kategori'),
                items: AppConstants.announcementCategories.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (value) => setState(() => _category = value ?? 'Umum'),
              ),
              const SizedBox(height: 12),
              TextField(controller: _content, maxLines: 5, decoration: const InputDecoration(labelText: 'Isi Info')),
              const SizedBox(height: 12),
              OutlinedButton.icon(onPressed: _loading ? null : _upload, icon: const Icon(Icons.image), label: Text(_imageUrl.isEmpty ? 'Upload gambar' : 'Gambar siap')),
              const SizedBox(height: 12),
              ElevatedButton.icon(onPressed: _loading ? null : _save, icon: const Icon(Icons.save), label: const Text('Simpan')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ListPanel() {
    return StreamBuilder<List<AnnouncementModel>>(
      stream: FirestoreService.instance.watchAnnouncements(),
      builder: (context, snapshot) {
        final items = snapshot.data ?? [];
        if (items.isEmpty) return const EmptyState(message: 'Belum ada info.');
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemBuilder: (_, index) {
            final item = items[index];
            return Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.campaign)),
                title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                subtitle: Text(item.category),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => FirestoreService.instance.deleteAnnouncement(item.id),
                ),
              ),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemCount: items.length,
        );
      },
    );
  }

  void _showForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: _FormPanel(),
      ),
    );
  }
}

class _BottomAddButton extends StatelessWidget {
  const _BottomAddButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton.icon(onPressed: onTap, icon: const Icon(Icons.add), label: const Text('Tambah Info')),
    );
  }
}
