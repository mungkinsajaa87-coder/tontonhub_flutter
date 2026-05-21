import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryModel {
  HistoryModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    this.createdAt,
  });

  final String id;
  final String userId;
  final String title;
  final String description;
  final dynamic createdAt;

  factory HistoryModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return HistoryModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      createdAt: data['createdAt'],
    );
  }
}
