import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'screens/auth/auth_gate.dart';

class TontonHubApp extends StatelessWidget {
  const TontonHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TontonHub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AuthGate(),
    );
  }
}
