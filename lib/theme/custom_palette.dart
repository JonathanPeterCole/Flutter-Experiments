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
    this.splash,
    this.highlight,
    this.shadow,
    this.textPrimary,
    this.textSecondary,
    this.divider,
    this.danger,
  });

  final Brightness brightness;
  final Color primary;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color buttonForeground;
  final Color splash;
  final Color highlight;
  final Color shadow;
  final Color textPrimary;
  final Color textSecondary;
  final Color divider;
  final Color danger;

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
        surface: this.surface,
      ),
      primaryColor: this.primary,
      accentColor: this.secondary,
      scaffoldBackgroundColor: this.background,
      canvasColor: this.surface,
      cardColor: this.surface,
      dividerColor: this.divider,
      // Inkwell & Button Theming
      splashFactory: InkRipple.splashFactory,
      splashColor: this.splash,
      highlightColor: this.highlight,
      buttonColor: this.primary,
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary
      ),
      // Text Theming
      primaryTextTheme: defaultThemeData.textTheme.apply(
        bodyColor: this.textPrimary,
        displayColor: this.textPrimary,
      ),
      // AppBar Theming
      appBarTheme: AppBarTheme(
        color: this.surface,
        shadowColor: this.shadow,
        brightness: this.brightness,
        iconTheme: IconThemeData(
          color: this.textPrimary
        ),
        actionsIconTheme: IconThemeData(
          color: this.textPrimary
        )
      ),
      // FAB Theming
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: this.buttonForeground,
      ),
      // Bottom Nav Theming
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: this.primary,
        unselectedItemColor: this.textSecondary,
      ),
      // Snackbar Theming
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}