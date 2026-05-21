import 'package:flutter/material.dart';

class SetupWarningScreen extends StatelessWidget {
  const SetupWarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('TontonHub', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                  SizedBox(height: 12),
                  Text(
                    'Firebase belum dikonfigurasi. Jalankan flutterfire configure, aktifkan Authentication, Firestore, dan Storage di Firebase Console, lalu jalankan ulang aplikasi.',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
