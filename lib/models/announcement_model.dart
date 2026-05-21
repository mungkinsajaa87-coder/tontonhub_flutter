import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementModel {
  AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.imageUrl = '',
    this.createdBy = '',
    this.createdAt,
  });

  final String id;
  final String title;
  final String content;
  final String category;
  final String imageUrl;
  final String createdBy;
  final dynamic createdAt;

  factory AnnouncementModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return AnnouncementModel(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      category: data['category'] ?? 'Umum',
      imageUrl: data['imageUrl'] ?? '',
      createdBy: data['createdBy'] ?? '',
      createdAt: data['createdAt'],
    );
  }
}
