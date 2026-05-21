import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationModel {
  RegistrationModel({
    required this.id,
    required this.videoId,
    required this.videoTitle,
    required this.userId,
    required this.userName,
    required this.status,
    this.proofUrl = '',
    this.registeredAt,
  });

  final String id;
  final String videoId;
  final String videoTitle;
  final String userId;
  final String userName;
  final String status;
  final String proofUrl;
  final dynamic registeredAt;

  factory RegistrationModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return RegistrationModel(
      id: doc.id,
      videoId: data['videoId'] ?? '',
      videoTitle: data['videoTitle'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      status: data['status'] ?? 'pending',
      proofUrl: data['proofUrl'] ?? '',
      registeredAt: data['registeredAt'],
    );
  }
}
