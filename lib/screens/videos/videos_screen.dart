import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../models/app_user.dart';
import '../../models/video_model.dart';
import '../../services/firestore_service.dart';
import '../../widgets/empty_state.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Streaming')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Cari video, channel, atau kategori...'),
              onChanged: (value) => setState(() => _query = value.toLowerCase()),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<VideoModel>>(
              stream: FirestoreService.instance.watchVideos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                final items = (snapshot.data ?? []).where((video) {
                  return video.title.toLowerCase().contains(_query) ||
                      video.description.toLowerCase().contains(_query) ||
                      video.channelName.toLowerCase().contains(_query);
                }).toList();
                if (items.isEmpty) return const EmptyState(message: 'Video belum tersedia.', icon: Icons.video_library_outlined);
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width >= 900 ? 3 : 1,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: MediaQuery.of(context).size.width >= 900 ? 1.15 : 1.55,
                  ),
                  itemBuilder: (_, index) => _VideoTile(video: items[index]),
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

class _VideoTile extends StatelessWidget {
  const _VideoTile({required this.video});
  final VideoModel video;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => showDialog(context: context, builder: (_) => _VideoDetail(video: video)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: video.thumbnailUrl.isNotEmpty
                      ? Image.network(video.thumbnailUrl, width: double.infinity, fit: BoxFit.cover)
                      : Container(
                          width: double.infinity,
                          color: Theme.of(context).colorScheme.primaryContainer,
                          child: const Icon(Icons.play_circle_fill, size: 54),
                        ),
                ),
              ),
              const SizedBox(height: 10),
              Text(video.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
              const SizedBox(height: 3),
              Text(video.channelName, maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.visibility_outlined, size: 16),
                  const SizedBox(width: 4),
                  Text('${video.views} views'),
                  const SizedBox(width: 12),
                  const Icon(Icons.schedule, size: 16),
                  const SizedBox(width: 4),
                  Expanded(child: Text(video.duration, overflow: TextOverflow.ellipsis)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VideoDetail extends StatefulWidget {
  const _VideoDetail({required this.video});
  final VideoModel video;

  @override
  State<_VideoDetail> createState() => _VideoDetailState();
}

class _VideoDetailState extends State<_VideoDetail> {
  final _comment = TextEditingController();
  VideoPlayerController? _controller;
  bool _loading = false;
  bool _playerReady = false;

  @override
  void initState() {
    super.initState();
    _prepareVideo();
  }

  Future<void> _prepareVideo() async {
    if (widget.video.videoUrl.isEmpty) return;
    try {
      final controller = VideoPlayerController.networkUrl(Uri.parse(widget.video.videoUrl));
      await controller.initialize();
      await controller.setLooping(false);
      if (!mounted) return;
      setState(() {
        _controller = controller;
        _playerReady = true;
      });
    } catch (_) {
      if (mounted) setState(() => _playerReady = false);
    }
  }

  @override
  void dispose() {
    _comment.dispose();
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _markWatched(AppUser user) async {
    setState(() => _loading = true);
    try {
      await FirestoreService.instance.markVideoWatched(widget.video, user);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Riwayat tontonan berhasil disimpan.')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _subscribe(AppUser user) async {
    setState(() => _loading = true);
    try {
      await FirestoreService.instance.subscribeCreator(widget.video, user);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Subscribe channel berhasil.')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _sendComment(AppUser user) async {
    final text = _comment.text.trim();
    if (text.isEmpty) return;
    await FirestoreService.instance.addComment(widget.video, user, text);
    _comment.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.video.title),
      content: SizedBox(
        width: 720,
        child: SingleChildScrollView(
          child: StreamBuilder<AppUser?>(
            stream: FirestoreService.instance.watchCurrentUser(),
            builder: (context, snapshot) {
              final user = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AspectRatio(
                    aspectRatio: _playerReady && _controller != null ? _controller!.value.aspectRatio : 16 / 9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: _playerReady && _controller != null
                          ? Stack(
                              alignment: Alignment.center,
                              children: [
                                VideoPlayer(_controller!),
                                IconButton.filled(
                                  onPressed: () {
                                    setState(() {
                                      _controller!.value.isPlaying ? _controller!.pause() : _controller!.play();
                                    });
                                  },
                                  icon: Icon(_controller!.value.isPlaying ? Icons.pause : Icons.play_arrow),
                                ),
                              ],
                            )
                          : Container(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              child: const Center(child: Text('Video player siap setelah URL video valid diinput.')),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(widget.video.description),
                  const SizedBox(height: 10),
                  Text('Channel: ${widget.video.channelName}'),
                  Text('Durasi: ${widget.video.duration}'),
                  Text('Views: ${widget.video.views}'),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ElevatedButton.icon(
                        onPressed: user == null || _loading ? null : () => _markWatched(user),
                        icon: const Icon(Icons.history),
                        label: const Text('Simpan Riwayat Tonton'),
                      ),
                      OutlinedButton.icon(
                        onPressed: user == null || _loading ? null : () => _subscribe(user),
                        icon: const Icon(Icons.subscriptions_outlined),
                        label: const Text('Subscribe Channel'),
                      ),
                    ],
                  ),
                  const Divider(height: 28),
                  const Text('Komentar', style: TextStyle(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: _comment, decoration: const InputDecoration(hintText: 'Tulis komentar...'))),
                      IconButton(onPressed: user == null ? null : () => _sendComment(user), icon: const Icon(Icons.send)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirestoreService.instance.watchComments(widget.video.id),
                    builder: (context, commentSnapshot) {
                      final docs = commentSnapshot.data?.docs ?? [];
                      if (docs.isEmpty) return const Text('Belum ada komentar.');
                      return Column(
                        children: docs.map((doc) {
                          final data = doc.data();
                          return ListTile(
                            dense: true,
                            leading: const CircleAvatar(child: Icon(Icons.person, size: 18)),
                            title: Text(data['userName'] ?? 'User'),
                            subtitle: Text(data['comment'] ?? ''),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup'))],
    );
  }
}
