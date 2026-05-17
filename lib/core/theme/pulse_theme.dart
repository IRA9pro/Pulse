import 'package:flutter/material.dart';

class PulseTheme {
  static const Color neonCyan = Color(0xFF00FFFF);
  static const Color background = Color(0xFF080808);
  static const Color surface = Color(0xFF121212);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: neonCyan,
        secondary: neonCyan,
        surface: surface,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          letterSpacing: 4,
          color: Colors.white,
        ),
        titleMedium: TextStyle(
          color: Colors.grey,
          letterSpacing: 1.1,
          fontSize: 14,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: neonCyan, width: 1),
        ),
        prefixIconColor: neonCyan.withValues(alpha: 0.7),
      ),
    );
  }
}
