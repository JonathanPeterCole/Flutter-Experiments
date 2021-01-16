import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_experiments/theme/custom_theme.dart';

/// A custom AppBar that adapts to the platform.
/// 
/// Displays a Material AppBar on Android, and a CupertinoNavigationBar on iOS.
class PlatformAppBar extends StatelessWidget implements PreferredSizeWidget {

  PlatformAppBar(BuildContext context, {
    Key key,
    this.title,
    this.actions,
    this.bottom,
    this.backgroundColor,
    this.backButtonText,
    this.centerTitle,
  }) : platform = Theme.of(context).platform,
       super(key: key);

  /// The primary widget displayed in the app bar.
  final Widget title;

  /// Widgets to display in a row after the [title] widget.
  final List<Widget> actions;

  /// This widget appears across the bottom of the app bar.
  final PreferredSizeWidget bottom;

  /// The background color.
  final Color backgroundColor;

  /// The text to display next to the back button.
  /// Only applies to iOS.
  final String backButtonText;

  /// Whether or not the title should be centered.
  /// Only applies to Android. On iOS this will always be true.
  final bool centerTitle;

  /// The current platform.
  final TargetPlatform platform;

  @override
  Size get preferredSize => Size.fromHeight(
    (platform == TargetPlatform.android ? kToolbarHeight : kMinInteractiveDimensionCupertino) + 
    (this.bottom?.preferredSize?.height ?? 0.0));

  @override
  Widget build(BuildContext context) => platform == TargetPlatform.android 
    ? materialAppBar(context) : cupertinoAppBar(context);

  Widget materialAppBar(BuildContext context) => AppBar(
    title: title,
    actions: actions,
    bottom: bottom,
    backgroundColor: backgroundColor ?? CustomTheme.of(context).surface,
    centerTitle: centerTitle,
  );

  Widget cupertinoAppBar(BuildContext context) => CupertinoNavigationBar(
    middle: title,
    trailing: actions != null ? Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: actions,
    ) : null,
    previousPageTitle: backButtonText,
    actionsForegroundColor: CustomTheme.of(context).primary,
    backgroundColor: (backgroundColor ?? CustomTheme.of(context).surface).withOpacity(0.8),
    border: Border.all(style: BorderStyle.none),
  );
}