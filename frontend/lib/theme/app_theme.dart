import 'package:flutter/material.dart';

final appTheme = ThemeData(
  useMaterial3: true,
  colorSchemeSeed: Colors.indigo,
  scaffoldBackgroundColor: Colors.grey[100],

  appBarTheme: const AppBarTheme(
    centerTitle: true,
  ),

  cardTheme: CardThemeData(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
  ),
);
