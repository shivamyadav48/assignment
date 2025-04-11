import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: const Color(0xFFE0F7FA), // Light blue
    hintColor: const Color(0xFFB0BEC5), // Grey
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: const Color(0xFF0139FF), // Teal

    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: const OutlineInputBorder(),
      labelStyle: const TextStyle(color: Colors.black54),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFE6EBFF)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE6EBFF),
        foregroundColor: Colors.black87,

      ),
    ),
  );
}
