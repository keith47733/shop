import 'package:flutter/material.dart';

import '../helpers/custom_route.dart';

class AppTheme {
  static ThemeData lightTheme(ColorScheme? lightColorScheme) {
    ColorScheme scheme = lightColorScheme ??
        ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
        );
    return ThemeData(
      fontFamily: 'SourceSansPro',
      colorScheme: scheme,
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {TargetPlatform.android: CustomPageTransitionBuilder()},
      ),
    );
  }

  static ThemeData darkTheme(ColorScheme? darkColorScheme) {
    ColorScheme scheme =
        darkColorScheme ?? ColorScheme.fromSeed(seedColor: Colors.blueGrey, brightness: Brightness.dark);
    return ThemeData(
      fontFamily: 'SourceSansPro',
      colorScheme: scheme,
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {TargetPlatform.android: CustomPageTransitionBuilder()},
      ),
    );
  }
}
