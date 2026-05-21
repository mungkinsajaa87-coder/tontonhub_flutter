import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  StorageService._();
  static final instance = StorageService._();

  final ImagePicker _picker = ImagePicker();

  Future<String?> pickAndUploadImage({required String folder}) async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
      maxWidth: 1400,
    );
    if (picked == null) return null;

    final bytes = await picked.readAsBytes();
    final safeFileName = picked.name.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_$safeFileName';
    final ref = FirebaseStorage.instance.ref().child('$folder/$fileName');

    await ref.putData(bytes, SettableMetadata(contentType: _contentType(safeFileName)));
    final url = await ref.getDownloadURL();

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && uid.isNotEmpty) {
      await FirebaseFirestore.instance.collection('media_uploads').add({
        'userId': uid,
        'folder': folder,
        'fileName': safeFileName,
        'fileUrl': url,
        'type': 'image',
        'uploadedAt': FieldValue.serverTimestamp(),
      });
    }

    return url;
  }

  String _contentType(String filename) {
    final lower = filename.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }
}
