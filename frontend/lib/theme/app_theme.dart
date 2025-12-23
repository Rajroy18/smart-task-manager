import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.indigo,
    scaffoldBackgroundColor: const Color(0xFFF6F6FB),

    cardTheme: const CardThemeData(
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
  );
}
