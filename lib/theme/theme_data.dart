import 'package:flutter/material.dart';

class TodoThemeData {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: const ColorScheme.light(),
      textTheme: TextTheme(bodyMedium: todoItemTextStyle),
      toggleableActiveColor: Colors.purple,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: const ColorScheme.dark(),
      textTheme: TextTheme(bodyMedium: todoItemTextStyle),
      toggleableActiveColor: Colors.purple,
      appBarTheme: const AppBarTheme(backgroundColor: Colors.black12),
    );
  }

  static TextStyle get todoItemTextStyle {
    return const TextStyle(fontFamily: 'Raleway', fontSize: 20);
  }
}
