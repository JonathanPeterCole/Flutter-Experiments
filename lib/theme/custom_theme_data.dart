import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A class to quickly generate flutter themes from a simple color palette.
class CustomThemeData {
  const CustomThemeData(this.brightness, {
    this.primary,
    this.secondary,
    this.background,
    this.surface,
    this.textPrimary,
    this.textSecondary,
    this.onPrimary,
    this.splash,
    this.highlight,
    this.shadow,
    this.divider,
    this.danger,
  });

  const CustomThemeData.light()
    : brightness = Brightness.light,
      primary = const Color.fromRGBO(104, 124, 255, 1),
      secondary = const Color.fromRGBO(104, 124, 255, 1),
      background = const Color.fromRGBO(242, 245, 248, 1),
      surface = const Color.fromRGBO(255, 255, 255, 1),
      textPrimary = const Color.fromRGBO(12, 18, 26, 1),
      textSecondary = const Color.fromRGBO(120, 125, 135, 1),
      onPrimary = const Color.fromRGBO(255, 255, 255, 1),
      splash = const Color.fromRGBO(104, 124, 255, 0.2),
      highlight = const Color.fromRGBO(104, 124, 255, 0.1),
      shadow = const Color.fromRGBO(55, 75, 91, 0.2),
      divider = const Color.fromRGBO(0, 0, 0, 0.3),
      danger = const Color.fromRGBO(210, 65, 65, 1);

  const CustomThemeData.dark()
    : brightness = Brightness.dark,
      primary = const Color.fromRGBO(104, 124, 255, 1),
      secondary = const Color.fromRGBO(104, 124, 255, 1),
      background = const Color.fromRGBO(12, 18, 26, 1),
      surface = const Color.fromRGBO(35, 40, 50, 1),
      textPrimary = const Color.fromRGBO(255, 255, 255, 1),
      textSecondary = const Color.fromRGBO(120, 125, 135, 1),
      onPrimary = const Color.fromRGBO(255, 255, 255, 1),
      splash = const Color.fromRGBO(104, 124, 255, 0.2),
      highlight = const Color.fromRGBO(104, 124, 255, 0.1),
      shadow = const Color.fromRGBO(0, 0, 0, 0.2),
      divider = const Color.fromRGBO(255, 255, 255, 0.3),
      danger = const Color.fromRGBO(210, 65, 65, 1);

  /// The theme brightness.
  final Brightness brightness;
  /// The primary color.
  final Color primary;
  /// The secondary color.
  final Color secondary;
  /// The background (applies to scaffold).
  final Color background;
  /// The surface color (applies to cards, appbars, bottom nav, and other surfaces).
  final Color surface;
  /// The primary text color.
  final Color textPrimary;
  /// The secondary text color.
  final Color textSecondary;
  /// The color for text and icons against a primary color background.
  final Color onPrimary;
  /// The ink splash color (applies to InkWell's Material splash effects).
  final Color splash;
  /// The highlight color (applies to button's whilst pressed).
  final Color highlight;
  /// The shadow color (applies to AppBar elevation).
  final Color shadow;
  /// The divider color.
  final Color divider;
  /// The danger color (applies to PlatformButtonWidget when the danger param is set to true)
  final Color danger;

  /// Copy the current theme with new properties.
  CustomThemeData copyWith({
    Brightness brightness,
    Color primary,
    Color secondary,
    Color background,
    Color surface,
    Color textPrimary,
    Color textSecondary,
    Color onPrimary,
    Color splash,
    Color highlight,
    Color shadow,
    Color divider,
    Color danger,
  }) => CustomThemeData(
    brightness ?? this.brightness,
    primary: primary ?? this.primary,
    secondary: secondary ?? this.secondary,
    surface: surface ?? this.surface,
    textPrimary: textPrimary ?? this.textPrimary,
    textSecondary: textSecondary ?? this.textSecondary,
    onPrimary: onPrimary ?? this.onPrimary,
    splash: splash ?? this.splash,
    highlight: highlight ?? this.highlight,
    shadow: shadow ?? this.shadow,
    divider: divider ?? this.divider,
    danger: danger ?? this.danger,
  );

  /// Generate a material theme from the palette
  ThemeData get materialTheme {
    // Get the default color scheme based on the brightness
    ColorScheme defaultColorScheme = brightness == Brightness.light ? ColorScheme.light() : ColorScheme.dark();
    ThemeData defaultThemeData = brightness == Brightness.light ? ThemeData.light() : ThemeData.dark();
    CupertinoTextThemeData defaultCupertinoTextThemeData = CupertinoTextThemeData();
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
        foregroundColor: this.onPrimary,
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
      // Cupertino Styles
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: this.brightness,
        primaryColor: this.primary,
        primaryContrastingColor: this.onPrimary,
        barBackgroundColor: this.surface,
        scaffoldBackgroundColor: this.background,
        textTheme: defaultCupertinoTextThemeData.copyWith(
          primaryColor: this.textPrimary,
          navTitleTextStyle: defaultCupertinoTextThemeData.navTitleTextStyle.copyWith(color: this.textPrimary)
        )
      )
    );
  }
}