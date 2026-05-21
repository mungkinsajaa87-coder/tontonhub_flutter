import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/announcement_model.dart';
import '../models/app_user.dart';
import '../models/history_model.dart';
import '../models/registration_model.dart';
import '../models/video_model.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser?.uid ?? '';

  Stream<AppUser?> watchCurrentUser() {
    final currentUid = uid;
    if (currentUid.isEmpty) return const Stream.empty();
    return _db.collection('users').doc(currentUid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return AppUser.fromDoc(doc);
    });
  }

  Stream<List<AppUser>> watchUsers() {
    return _db.collection('users').orderBy('createdAt', descending: true).snapshots().map(
          (snapshot) => snapshot.docs.map(AppUser.fromDoc).toList(),
        );
  }

  Stream<List<AnnouncementModel>> watchAnnouncements() {
    return _db.collection('announcements').orderBy('createdAt', descending: true).snapshots().map(
          (snapshot) => snapshot.docs.map(AnnouncementModel.fromDoc).toList(),
        );
  }

  Stream<List<VideoModel>> watchVideos() {
    return _db.collection('videos').orderBy('createdAt', descending: true).snapshots().map(
          (snapshot) => snapshot.docs.map(VideoModel.fromDoc).toList(),
        );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchComments(String videoId) {
    return _db
        .collection('videos')
        .doc(videoId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<List<RegistrationModel>> watchAllRegistrations() {
    return _db
        .collection('subscriptions')
        .orderBy('registeredAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(RegistrationModel.fromDoc).toList());
  }

  Stream<List<RegistrationModel>> watchMyRegistrations() {
    return _db
        .collection('subscriptions')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(RegistrationModel.fromDoc).toList());
  }

  Stream<List<HistoryModel>> watchMyHistory() {
    return _db.collection('activity_history').where('userId', isEqualTo: uid).snapshots().map((snapshot) {
      final items = snapshot.docs.map(HistoryModel.fromDoc).toList();
      items.sort((a, b) {
        final aDate = (a.createdAt is Timestamp) ? (a.createdAt as Timestamp).toDate() : DateTime(1970);
        final bDate = (b.createdAt is Timestamp) ? (b.createdAt as Timestamp).toDate() : DateTime(1970);
        return bDate.compareTo(aDate);
      });
      return items;
    });
  }

  Future<void> updateProfile({
    required String name,
    required String idPengguna,
    required String minatKonten,
    required String phone,
    String? photoUrl,
  }) async {
    final data = <String, dynamic>{
      'name': name.trim(),
      'idPengguna': idPengguna.trim(),
      'minatKonten': minatKonten.trim(),
      'phone': phone.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (photoUrl != null && photoUrl.isNotEmpty) data['photoUrl'] = photoUrl;
    await _db.collection('users').doc(uid).update(data);
    await addHistory('Update Profil', 'Data profil berhasil diperbarui.');
  }

  Future<void> addAnnouncement({
    required String title,
    required String content,
    required String category,
    String imageUrl = '',
  }) async {
    await _db.collection('announcements').add({
      'title': title.trim(),
      'content': content.trim(),
      'category': category,
      'imageUrl': imageUrl,
      'createdBy': uid,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await addHistory('Tambah Info', 'Creator menambahkan info $title.');
  }

  Future<void> deleteAnnouncement(String id) async {
    await _db.collection('announcements').doc(id).delete();
  }

  Future<void> addVideo({
    required String title,
    required String description,
    required String channelName,
    required String duration,
    required String videoUrl,
    int views = 0,
    String thumbnailUrl = '',
  }) async {
    await _db.collection('videos').add({
      'title': title.trim(),
      'description': description.trim(),
      'channelName': channelName.trim(),
      'duration': duration.trim(),
      'views': views,
      'thumbnailUrl': thumbnailUrl,
      'videoUrl': videoUrl.trim(),
      'createdBy': uid,
      'status': 'published',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await addHistory('Tambah Video', 'Creator menambahkan video $title.');
  }

  Future<void> deleteVideo(String id) async {
    await _db.collection('videos').doc(id).delete();
  }

  Future<void> markVideoWatched(VideoModel video, AppUser user) async {
    await _db.collection('videos').doc(video.id).update({
      'views': FieldValue.increment(1),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await _db.collection('watch_history').add({
      'videoId': video.id,
      'videoTitle': video.title,
      'userId': user.uid,
      'userName': user.name,
      'watchedAt': FieldValue.serverTimestamp(),
    });
    await addHistory('Menonton Video', 'Kamu menonton video ${video.title}.');
  }

  Future<void> subscribeCreator(VideoModel video, AppUser user) async {
    final existing = await _db
        .collection('subscriptions')
        .where('videoId', isEqualTo: video.id)
        .where('userId', isEqualTo: user.uid)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      throw Exception('Kamu sudah subscribe creator/channel video ini.');
    }

    await _db.collection('subscriptions').add({
      'videoId': video.id,
      'videoTitle': video.title,
      'creatorId': video.createdBy,
      'channelName': video.channelName,
      'userId': user.uid,
      'userName': user.name,
      'status': 'subscribed',
      'registeredAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await addHistory('Subscribe Creator', 'Kamu subscribe channel ${video.channelName}.');
  }

  Future<void> addComment(VideoModel video, AppUser user, String text) async {
    if (text.trim().isEmpty) return;
    await _db.collection('videos').doc(video.id).collection('comments').add({
      'userId': user.uid,
      'userName': user.name,
      'comment': text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    await addHistory('Komentar Video', 'Kamu memberi komentar pada video ${video.title}.');
  }

  Future<void> updateRegistrationStatus(RegistrationModel item, String status) async {
    await _db.collection('subscriptions').doc(item.id).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await _db.collection('activity_history').add({
      'userId': item.userId,
      'title': 'Status Subscribe Diperbarui',
      'description': 'Status subscribe ${item.videoTitle} menjadi $status.',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addHistory(String title, String description) async {
    if (uid.isEmpty) return;
    await _db.collection('activity_history').add({
      'userId': uid,
      'title': title,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
