import 'package:flutter/material.dart';

import '../../models/video_model.dart';
import '../../services/firestore_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/empty_state.dart';

class CreatorVideosScreen extends StatefulWidget {
  const CreatorVideosScreen({super.key});

  @override
  State<CreatorVideosScreen> createState() => _CreatorVideosScreenState();
}

class _CreatorVideosScreenState extends State<CreatorVideosScreen> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _channelName = TextEditingController();
  final _duration = TextEditingController();
  final _videoUrl = TextEditingController();
  String _thumbnailUrl = '';
  bool _loading = false;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _channelName.dispose();
    _duration.dispose();
    _videoUrl.dispose();
    super.dispose();
  }

  Future<void> _upload() async {
    setState(() => _loading = true);
    try {
      final url = await StorageService.instance.pickAndUploadImage(folder: 'video_thumbnails');
      if (url != null) setState(() => _thumbnailUrl = url);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    if (_title.text.trim().isEmpty || _description.text.trim().isEmpty || _channelName.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Judul, deskripsi, dan nama channel wajib diisi.')));
      return;
    }
    setState(() => _loading = true);
    try {
      await FirestoreService.instance.addVideo(
        title: _title.text,
        description: _description.text,
        channelName: _channelName.text,
        duration: _duration.text.isEmpty ? '00:00' : _duration.text,
        videoUrl: _videoUrl.text,
        thumbnailUrl: _thumbnailUrl,
      );
      _title.clear();
      _description.clear();
      _channelName.clear();
      _duration.clear();
      _videoUrl.clear();
      setState(() => _thumbnailUrl = '');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Video berhasil ditambahkan.')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Creator Studio Video')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;
          return wide
              ? Row(children: [SizedBox(width: 440, child: _FormPanel()), Expanded(child: _ListPanel())])
              : Column(children: [Expanded(child: _ListPanel()), Padding(padding: const EdgeInsets.all(16), child: ElevatedButton.icon(onPressed: () => _showForm(context), icon: const Icon(Icons.add), label: const Text('Tambah Video')))]);
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0x1A1565C0),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.video_call_rounded,
                      color: Color(0xFF1565C0),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Upload Konten Video',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Tambahkan judul, deskripsi, channel, durasi, dan URL video untuk ditampilkan ke subscriber.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 18),
              TextField(controller: _title, decoration: const InputDecoration(labelText: 'Judul Video')),
              const SizedBox(height: 12),
              TextField(controller: _description, maxLines: 4, decoration: const InputDecoration(labelText: 'Deskripsi')),
              const SizedBox(height: 12),
              TextField(controller: _channelName, decoration: const InputDecoration(labelText: 'Nama Channel / Creator')),
              const SizedBox(height: 12),
              TextField(controller: _duration, decoration: const InputDecoration(labelText: 'Durasi, contoh: 12:30')),
              const SizedBox(height: 12),
              TextField(controller: _videoUrl, decoration: const InputDecoration(labelText: 'URL Video MP4 / streaming')),
              const SizedBox(height: 12),
              OutlinedButton.icon(onPressed: _loading ? null : _upload, icon: const Icon(Icons.image), label: Text(_thumbnailUrl.isEmpty ? 'Upload thumbnail' : 'Thumbnail siap')),
              const SizedBox(height: 12),
              ElevatedButton.icon(onPressed: _loading ? null : _save, icon: const Icon(Icons.save), label: const Text('Simpan Video')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ListPanel() {
    return StreamBuilder<List<VideoModel>>(
      stream: FirestoreService.instance.watchVideos(),
      builder: (context, snapshot) {
        final items = snapshot.data ?? [];
        if (items.isEmpty) return const EmptyState(message: 'Belum ada video.', icon: Icons.video_library_outlined);
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemBuilder: (_, index) {
            final video = items[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(backgroundImage: video.thumbnailUrl.isNotEmpty ? NetworkImage(video.thumbnailUrl) : null, child: video.thumbnailUrl.isEmpty ? const Icon(Icons.play_arrow) : null),
                title: Text(video.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                subtitle: Text('${video.channelName} • ${video.duration} • ${video.views} views'),
                trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => FirestoreService.instance.deleteVideo(video.id)),
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
