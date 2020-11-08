import 'package:flutter/material.dart';
import 'package:flutter_experiments/theme/custom_palette.dart';

/// Custom theme manager to create the custom light and dark themes.
class CustomTheme {
  static const CustomPalette themeLight = CustomPalette(Brightness.light,
    primary: Color.fromRGBO(104, 124, 255, 1),
    secondary: Color.fromRGBO(104, 124, 255, 1),
    background: Color.fromRGBO(242, 245, 248, 1),
    surface: Color.fromRGBO(255, 255, 255, 1),
    buttonForeground: Color.fromRGBO(255, 255, 255, 1),
    splash: Color.fromRGBO(104, 124, 255, 0.2),
    highlight: Color.fromRGBO(104, 124, 255, 0.1),
    shadow: Color.fromRGBO(55, 75, 91, 0.2),
    textPrimary: Color.fromRGBO(12, 18, 26, 1),
    textSecondary: Color.fromRGBO(120, 125, 135, 1),
    divider:  Color.fromRGBO(0, 0, 0, 0.3),
  );
  static const CustomPalette themeDark = CustomPalette(Brightness.dark,
    primary: Color.fromRGBO(104, 124, 255, 1),
    secondary: Color.fromRGBO(104, 124, 255, 1),
    background: Color.fromRGBO(12, 18, 26, 1),
    surface: Color.fromRGBO(35, 40, 50, 1),
    buttonForeground: Color.fromRGBO(255, 255, 255, 1),
    splash: Color.fromRGBO(104, 124, 255, 0.2),
    highlight: Color.fromRGBO(104, 124, 255, 0.1),
    shadow: Color.fromRGBO(0, 0, 0, 0.2),
    textPrimary: Color.fromRGBO(255, 255, 255, 1),
    textSecondary: Color.fromRGBO(120, 125, 135, 1),
    divider:  Color.fromRGBO(255, 255, 255, 0.3),
  );

  /// Get the custom theme based on the context theme brightness
  static CustomPalette of(BuildContext context) {
    return brightness(Theme.of(context).brightness);
  }

  /// Get the custom theme based on the given brightness
  static CustomPalette brightness(Brightness brightness) {
    return brightness == Brightness.light ? themeLight : themeDark;
  }
}
