import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme(ColorScheme? lightColorScheme) {
    ColorScheme scheme = lightColorScheme ?? ColorScheme.fromSeed(seedColor: Colors.blueGrey);
    return ThemeData(
      // useMaterial3: true,
      fontFamily: 'Lato',
      colorScheme: scheme,
    );
  }

  static ThemeData darkTheme(ColorScheme? darkColorScheme) {
    ColorScheme scheme =
        darkColorScheme ?? ColorScheme.fromSeed(seedColor: Colors.blueGrey, brightness: Brightness.dark);
    return ThemeData(
      // useMaterial3: true,
      fontFamily: 'Lato',
      colorScheme: scheme,
    );
  }
}
