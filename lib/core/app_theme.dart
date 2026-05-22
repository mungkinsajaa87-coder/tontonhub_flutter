import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF0B1F3A);
  static const Color secondary = Color(0xFF1565C0);
  static const Color accent = Color(0xFF00A8E8);
  static const Color background = Color(0xFFF5F7FB);
  static const Color cardColor = Colors.white;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      fontFamily: 'Roboto',
      colorScheme: ColorScheme.fromSeed(
        seedColor: secondary,
        primary: primary,
        secondary: secondary,
        surface: cardColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: primary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 1,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: secondary,
            width: 1.5,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}