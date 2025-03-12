import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white,
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    cardColor: Colors.grey[900],
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
    ),
  );
}
