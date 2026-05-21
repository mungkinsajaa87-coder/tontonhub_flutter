import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../services/firestore_service.dart';
import '../creator/creator_shell.dart';
import '../student/student_shell.dart';
import 'login_screen.dart';
import 'setup_warning_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    if (Firebase.apps.isEmpty) return const SetupWarningScreen();

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (!authSnapshot.hasData) return const LoginScreen();

        return StreamBuilder(
          stream: FirestoreService.instance.watchCurrentUser(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            final user = userSnapshot.data;
            if (user == null) {
              return const Scaffold(body: Center(child: Text('Data pengguna belum ditemukan.')));
            }
            if (user.role == AppConstants.roleCreator) return const CreatorShell();
            return const StudentShell();
          },
        );
      },
    );
  }
}
