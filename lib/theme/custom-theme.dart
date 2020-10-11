import 'package:flutter/material.dart';
import 'package:flutter_experiments/theme/custom-palette.dart';

/// Custom theme manager to create the custom light and dark themes.
class CustomTheme {
  static const CustomPalette themeLight = CustomPalette(Brightness.light);
  static const CustomPalette themeDark = CustomPalette(Brightness.dark);

  /// Get the custom theme based on the context theme brightness
  static CustomPalette of(BuildContext context) {
    return brightness(Theme.of(context).brightness);
  }

  /// Get the custom theme based on the given brightness
  static CustomPalette brightness(Brightness brightness) {
    return brightness == Brightness.light ? themeLight : themeDark;
  }
}
