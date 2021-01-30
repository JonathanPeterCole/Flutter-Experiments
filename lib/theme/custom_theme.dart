import 'package:flutter/material.dart';
import 'package:flutter_experiments/theme/custom_theme_data.dart';

/// Custom theme manager to make CustomThemeData available in the widget tree.
class CustomTheme extends InheritedWidget {
  const CustomTheme({
    Key? key,
    required Widget child,
    CustomThemeData? theme,
    CustomThemeData? darkTheme
  }) : lightTheme = theme ?? const CustomThemeData.light(),
       darkTheme = darkTheme ?? const CustomThemeData.dark(),
       super(key: key, child: child);

  /// The light theme.
  final CustomThemeData lightTheme;
  /// The dark theme.
  final CustomThemeData darkTheme;

  /// Whether or not child widgets should be notified of changes.
  @override
  bool updateShouldNotify(CustomTheme old) => 
    lightTheme != old.lightTheme|| darkTheme != old.darkTheme;

  /// Get the custom theme from the widget tree.
  /// 
  /// If there's no CustomTheme widget in the tree, the default theme will be returned instead.
  static CustomThemeData of(BuildContext context) {
    final CustomTheme? instance = context.dependOnInheritedWidgetOfExactType<CustomTheme>();
    return MediaQuery.of(context).platformBrightness == Brightness.light
      ? instance?.lightTheme ?? const CustomThemeData.light()
      : instance?.darkTheme ?? const CustomThemeData.dark();
  }
}
