import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.idPengguna = '',
    this.minatKonten = '',
    this.phone = '',
    this.photoUrl = '',
    this.createdAt,
  });

  final String uid;
  final String name;
  final String email;
  final String role;
  final String idPengguna;
  final String minatKonten;
  final String phone;
  final String photoUrl;
  final dynamic createdAt;

  bool get isCreator => role == 'creator';

  factory AppUser.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return AppUser(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'subscriber',
      idPengguna: data['idPengguna'] ?? '',
      minatKonten: data['minatKonten'] ?? '',
      phone: data['phone'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role,
      'idPengguna': idPengguna,
      'minatKonten': minatKonten,
      'phone': phone,
      'photoUrl': photoUrl,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
