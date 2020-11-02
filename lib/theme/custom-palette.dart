import 'dart:ui';

import 'package:flutter/material.dart';

class CustomPalette {
  /// A class to quickly generate themes from a set of colors
  const CustomPalette(this.brightness, {
    this.primary,
    this.secondary,
    this.background,
    this.surface,
    this.buttonForeground,
    this.buttonSplash,
    this.shadow,
    this.textPrimary,
    this.textSecondary
  });

  final Brightness brightness;
  final Color primary;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color buttonForeground;
  final Color buttonSplash;
  final Color shadow;
  final Color textPrimary;
  final Color textSecondary;

  /// Generate a material theme from the palette
  ThemeData get materialTheme {
    // Get the default color scheme based on the brightness
    ColorScheme defaultColorScheme = brightness == Brightness.light ? ColorScheme.light() : ColorScheme.dark();
    ThemeData defaultThemeData = brightness == Brightness.light ? ThemeData.light() : ThemeData.dark();
    // Create the theme data
    return ThemeData(
      brightness: brightness,
      colorScheme: defaultColorScheme.copyWith(
        primary: this.primary,
        secondary: this.secondary,
        background: this.background,
        surface: this.surface
      ),
      primaryColor: this.primary,
      scaffoldBackgroundColor: this.background,
      canvasColor: this.surface,
      cardColor: this.surface,
      splashColor: this.primary.withOpacity(0.1),
      primaryTextTheme: defaultThemeData.textTheme.apply(
        bodyColor: this.textPrimary,
        displayColor: this.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        color: this.surface,
        shadowColor: this.shadow,
        brightness: this.brightness,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: this.buttonForeground,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: this.primary,
        unselectedItemColor: this.textSecondary,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      splashFactory: InkRipple.splashFactory
    );
  }
}