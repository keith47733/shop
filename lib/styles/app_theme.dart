import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme(ColorScheme? lightColorScheme) {
    // The ?? returns the expression on the left, unless it is null then it returns the expression on the right. This statement sets ColorScheme scheme to the system lightColorScheme if the device supports wallpaper themes. If not, lightColorScheme is null and ColorCheme scheme is set from a seedColor.
    ColorScheme scheme = lightColorScheme ??
        ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
        );
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
