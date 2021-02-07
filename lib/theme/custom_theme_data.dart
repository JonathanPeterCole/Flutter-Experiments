import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A class to quickly generate flutter themes from a simple color palette.
class CustomThemeData {
  const CustomThemeData({
    required this.brightness,
    required this.primary,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.onPrimary,
    required this.highlight,
    required this.shadow,
    required this.divider,
    required this.danger,
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
      highlight = const Color.fromRGBO(104, 124, 255, 0.2),
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
      highlight = const Color.fromRGBO(104, 124, 255, 0.2),
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
  /// The color used for ink splashes and iOS buttons with [CupertinoHighlightType.color].
  final Color highlight;
  /// The shadow color (applies to AppBar elevation).
  final Color shadow;
  /// The divider color.
  final Color divider;
  /// The danger color (applies to PlatformButtonWidget when the danger param is set to true)
  final Color danger;

  /// Copy the current theme with new properties.
  CustomThemeData copyWith({
    Brightness? brightness,
    Color? primary,
    Color? secondary,
    Color? background,
    Color? surface,
    Color? textPrimary,
    Color? textSecondary,
    Color? onPrimary,
    Color? highlight,
    Color? shadow,
    Color? divider,
    Color? danger,
  }) => CustomThemeData(
    brightness: brightness ?? this.brightness,
    primary: primary ?? this.primary,
    secondary: secondary ?? this.secondary,
    background: background ?? this.background,
    surface: surface ?? this.surface,
    textPrimary: textPrimary ?? this.textPrimary,
    textSecondary: textSecondary ?? this.textSecondary,
    onPrimary: onPrimary ?? this.onPrimary,
    highlight: highlight ?? this.highlight,
    shadow: shadow ?? this.shadow,
    divider: divider ?? this.divider,
    danger: danger ?? this.danger,
  );

  /// Generate a material theme from the palette
  ThemeData get materialTheme {
    // Get the default color scheme based on the brightness
    final ColorScheme defaultColorScheme =
        brightness == Brightness.light ? const ColorScheme.light() : const ColorScheme.dark();
    final ThemeData defaultThemeData =
        brightness == Brightness.light ? ThemeData.light() : ThemeData.dark();
    const CupertinoTextThemeData defaultCupertinoTextThemeData = CupertinoTextThemeData();
    // Create the theme data
    return ThemeData(
      brightness: brightness,
      colorScheme: defaultColorScheme.copyWith(
        primary: primary,
        secondary: secondary,
        background: background,
        surface: surface,
      ),
      primaryColor: primary,
      accentColor: secondary,
      scaffoldBackgroundColor: background,
      canvasColor: surface,
      cardColor: surface,
      dividerColor: divider,
      // Inkwell & Button Theming
      splashFactory: InkRipple.splashFactory,
      splashColor: defaultThemeData.platform == TargetPlatform.iOS ? Colors.transparent : highlight,
      highlightColor: highlight,
      buttonColor: primary,
      buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
      // Text Theming
      primaryTextTheme: defaultThemeData.textTheme.apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      // AppBar Theming
      appBarTheme: AppBarTheme(
        color: surface,
        shadowColor: shadow,
        brightness: brightness,
        iconTheme: IconThemeData(color: textPrimary),
        actionsIconTheme: IconThemeData(color: textPrimary),
      ),
      // FAB Theming
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: onPrimary,
      ),
      // Bottom Nav Theming
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: primary,
        unselectedItemColor: textSecondary,
      ),
      // Snackbar Theming
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      // Cupertino Styles
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: brightness,
        primaryColor: primary,
        primaryContrastingColor: onPrimary,
        barBackgroundColor: surface,
        scaffoldBackgroundColor: background,
        textTheme: defaultCupertinoTextThemeData.copyWith(
          primaryColor: textPrimary,
          navTitleTextStyle:
              defaultCupertinoTextThemeData.navTitleTextStyle.copyWith(color: textPrimary),
        ),
      ),
    );
  }
}
