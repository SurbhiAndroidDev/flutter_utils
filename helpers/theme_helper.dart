import 'package:elera/res/font_res.dart';
import 'package:flutter/material.dart';

import 'color_schemes.dart';

class ThemeHelper {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      brightness: Brightness.light,
      fontFamily: 'Urbanist-Regular',
      textTheme: const TextTheme(
        headlineLarge:
            TextStyle(fontFamily: FontRes.URBANIST_BOLD, fontSize: 24),
        headlineMedium:
            TextStyle(fontFamily: FontRes.URBANIST_BOLD, fontSize: 20),
        headlineSmall:
            TextStyle(fontFamily: FontRes.URBANIST_BOLD, fontSize: 18),
        titleLarge:
            TextStyle(fontFamily: FontRes.URBANIST_SEMIBOLD, fontSize: 18),
        titleMedium:
            TextStyle(fontFamily: FontRes.URBANIST_SEMIBOLD, fontSize: 16),
        titleSmall:
            TextStyle(fontFamily: FontRes.URBANIST_SEMIBOLD, fontSize: 14),
        bodyLarge:
            TextStyle(fontFamily: FontRes.URBANIST_REGULAR, fontSize: 16),
        bodyMedium:
            TextStyle(fontFamily: FontRes.URBANIST_REGULAR, fontSize: 14),
        bodySmall:
            TextStyle(fontFamily: FontRes.URBANIST_REGULAR, fontSize: 14),
        labelMedium:
            TextStyle(fontFamily: FontRes.URBANIST_REGULAR, fontSize: 14),
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      brightness: Brightness.dark,
      fontFamily: FontRes.URBANIST_REGULAR,
      textTheme: const TextTheme(
        headlineLarge:
            TextStyle(fontFamily: FontRes.URBANIST_BOLD, fontSize: 24),
        headlineMedium:
            TextStyle(fontFamily: FontRes.URBANIST_BOLD, fontSize: 20),
        headlineSmall:
            TextStyle(fontFamily: FontRes.URBANIST_BOLD, fontSize: 18),
        titleLarge:
            TextStyle(fontFamily: FontRes.URBANIST_SEMIBOLD, fontSize: 18),
        titleMedium:
            TextStyle(fontFamily: FontRes.URBANIST_SEMIBOLD, fontSize: 16),
        titleSmall:
            TextStyle(fontFamily: FontRes.URBANIST_SEMIBOLD, fontSize: 14),
        bodyLarge:
            TextStyle(fontFamily: FontRes.URBANIST_REGULAR, fontSize: 16),
        bodyMedium:
            TextStyle(fontFamily: FontRes.URBANIST_REGULAR, fontSize: 14),
        bodySmall:
            TextStyle(fontFamily: FontRes.URBANIST_REGULAR, fontSize: 12),
        labelMedium:
            TextStyle(fontFamily: FontRes.URBANIST_REGULAR, fontSize: 10),
      ),
    );
  }
}
