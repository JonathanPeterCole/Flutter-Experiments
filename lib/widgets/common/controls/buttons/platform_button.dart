import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_experiments/theme/custom_theme.dart';

/// A button widget that adapts to the current platform (iOS/Android).
class PlatformButton extends StatelessWidget {

  PlatformButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.danger = false,
    this.type = PlatformButtonType.Primary,
  }) : super(key: key);

  
  final Widget child;
  final VoidCallback? onPressed;
  final bool danger;
  final PlatformButtonType type;

  @override
  Widget build(BuildContext context) {
    // Get the button color
    Color buttonColor = danger ? CustomTheme.of(context).danger : CustomTheme.of(context).primary;
    Color buttonForegroundColor = CustomTheme.of(context).onPrimary;
    bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
    // Get the appropriate button
    if (isAndroid) {
      return androidButton(context, buttonColor, buttonForegroundColor);
    } else {
      return iosButton(context, buttonColor, buttonForegroundColor);
    }
  }

  Widget androidButton(BuildContext context, Color buttonColor, Color buttonForegroundColor) {
    if (type == PlatformButtonType.Primary) {
      return RaisedButton(
        child: child, 
        onPressed: onPressed,
        color: buttonColor,
        textColor: buttonForegroundColor,
        disabledTextColor: buttonForegroundColor.withOpacity(0.6),
        disabledColor: buttonColor.withOpacity(0.38),
      );
    } else {
      return FlatButton(
        child: child, 
        onPressed: onPressed,
        textColor: buttonColor,
        disabledTextColor: buttonColor.withOpacity(0.38),
      );
    }
  }

  Widget iosButton(BuildContext context, Color buttonColor, Color buttonForegroundColor) {
    // Get the button colors
    Color? backgroundColor = type == PlatformButtonType.Primary ? buttonColor : null;
    Color textColor = type == PlatformButtonType.Primary ? buttonForegroundColor : buttonColor;
    // Return the button
    return CupertinoButton(
      color: backgroundColor,
      disabledColor: backgroundColor != null ? backgroundColor.withOpacity(0.38)
        : Colors.transparent,
      child:  DefaultTextStyle(
        style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
          color: onPressed == null ? textColor.withOpacity(0.5) : textColor
        ),
        child: child,
      ),
      onPressed: onPressed,
    );
  }
}

enum PlatformButtonType {
  Primary, Secondary
}