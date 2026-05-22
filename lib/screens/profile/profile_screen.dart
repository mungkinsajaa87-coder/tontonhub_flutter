import 'package:flutter/material.dart';

import '../../models/app_user.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../services/storage_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _idPengguna = TextEditingController();
  final _minatKonten = TextEditingController();
  final _phone = TextEditingController();
  String _photoUrl = '';
  bool _initialized = false;
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _idPengguna.dispose();
    _minatKonten.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _fill(AppUser user) {
    if (_initialized) return;
    _name.text = user.name;
    _idPengguna.text = user.idPengguna;
    _minatKonten.text = user.minatKonten;
    _phone.text = user.phone;
    _photoUrl = user.photoUrl;
    _initialized = true;
  }

  Future<void> _uploadPhoto() async {
    setState(() => _loading = true);
    try {
      final url = await StorageService.instance.pickAndUploadImage(folder: 'profile_photos');
      if (url != null) setState(() => _photoUrl = url);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await FirestoreService.instance.updateProfile(
        name: _name.text,
        idPengguna: _idPengguna.text,
        minatKonten: _minatKonten.text,
        phone: _phone.text,
        photoUrl: _photoUrl,
      );
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil berhasil disimpan.')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [IconButton(onPressed: AuthService.instance.logout, icon: const Icon(Icons.logout))],
      ),
      body: StreamBuilder<AppUser?>(
        stream: FirestoreService.instance.watchCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final user = snapshot.data;
          if (user == null) return const Center(child: Text('Profil tidak ditemukan.'));
          _fill(user);
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF0B1F3A),
                                  Color(0xFF1565C0),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Profil Pengguna',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Kelola informasi akun dan data profil TontonHub.',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          CircleAvatar(
                            radius: 48,
                            backgroundImage: _photoUrl.isNotEmpty ? NetworkImage(_photoUrl) : null,
                            child: _photoUrl.isNotEmpty ? null : const Icon(Icons.person, size: 46),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            onPressed: _loading ? null : _uploadPhoto,
                            icon: const Icon(Icons.upload),
                            label: const Text('Upload Foto Profil'),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _name,
                            decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                            validator: (value) => value != null && value.trim().isNotEmpty ? null : 'Nama wajib diisi',
                          ),
                          const SizedBox(height: 12),
                          TextFormField(controller: _idPengguna, decoration: const InputDecoration(labelText: 'ID Pengguna')),
                          const SizedBox(height: 12),
                          TextFormField(controller: _minatKonten, decoration: const InputDecoration(labelText: 'Minat Konten / Divisi')),
                          const SizedBox(height: 12),
                          TextFormField(controller: _phone, decoration: const InputDecoration(labelText: 'No. HP')),
                          const SizedBox(height: 18),
                          ElevatedButton.icon(
                            onPressed: _loading ? null : _save,
                            icon: _loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save),
                            label: const Text('Simpan Profil'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
