import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final options = DefaultFirebaseOptions.currentPlatform;
    final isStillTemplate = options.apiKey.contains('ISI_DENGAN') ||
        options.appId.contains('ISI_DENGAN') ||
        options.projectId.contains('ISI_DENGAN');

    if (!isStillTemplate) {
      await Firebase.initializeApp(options: options);
    } else {
      debugPrint('Firebase masih memakai template. Jalankan flutterfire configure terlebih dahulu.');
    }
  } catch (error) {
    debugPrint('Firebase belum berhasil diinisialisasi: $error');
  }

  runApp(const TontonHubApp());
}
