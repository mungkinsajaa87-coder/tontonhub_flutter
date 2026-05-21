import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../core/constants.dart';

class AuthService {
  AuthService._();
  static final instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<void> login({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_authErrorMessage(e));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String idPengguna,
    required String minatKonten,
    required String role,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final uid = credential.user!.uid;
      await _db.collection('users').doc(uid).set({
        'uid': uid,
        'name': name.trim(),
        'email': email.trim(),
        'role': role,
        'idPengguna': idPengguna.trim(),
        'minatKonten': minatKonten.trim(),
        'phone': '',
        'photoUrl': '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await _db.collection('activity_history').add({
        'userId': uid,
        'title': 'Registrasi Akun',
        'description': 'Akun $role berhasil dibuat di TontonHub.',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      throw Exception(_authErrorMessage(e));
    }
  }

  Future<void> logout() async => _auth.signOut();

  String _authErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'user-not-found':
        return 'Akun tidak ditemukan.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email atau password salah.';
      case 'email-already-in-use':
        return 'Email sudah terdaftar.';
      case 'weak-password':
        return 'Password terlalu lemah, minimal gunakan 6 karakter.';
      default:
        return e.message ?? 'Terjadi kesalahan autentikasi.';
    }
  }
}

bool isCreatorCodeValid(String code) => code.trim() == AppConstants.creatorCode;
