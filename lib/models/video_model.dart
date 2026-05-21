import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  VideoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.channelName,
    required this.duration,
    required this.views,
    this.thumbnailUrl = '',
    this.videoUrl = '',
    this.createdBy = '',
    this.status = 'published',
    this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final String channelName;
  final String duration;
  final int views;
  final String thumbnailUrl;
  final String videoUrl;
  final String createdBy;
  final String status;
  final dynamic createdAt;

  factory VideoModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return VideoModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      channelName: data['channelName'] ?? data['location'] ?? '',
      duration: data['duration'] ?? data['dateText'] ?? '',
      views: int.tryParse('${data['views'] ?? data['quota'] ?? 0}') ?? 0,
      thumbnailUrl: data['thumbnailUrl'] ?? data['posterUrl'] ?? '',
      videoUrl: data['videoUrl'] ?? '',
      createdBy: data['createdBy'] ?? '',
      status: data['status'] ?? 'published',
      createdAt: data['createdAt'],
    );
  }
}
