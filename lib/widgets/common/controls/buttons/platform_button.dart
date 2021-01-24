import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_experiments/theme/custom_theme.dart';
import 'package:flutter_experiments/widgets/common/controls/buttons/platform_tappable.dart';

/// Creates a standard button with support for icons and labels, adapting the border-radius and 
/// child theming to match the current platform.
class PlatformButton extends StatefulWidget {

  PlatformButton({
    Key? key,
    this.onPressed,
    required this.label,
    this.leadingIcon,
    this.trailingIcon,
    this.color = Colors.transparent,
    this.foregroundColor,
    this.disabledColor,
    this.disabledForegroundColor,
    this.borderWidth,
    this.borderColor,
    this.disabledBorderColor,
    this.elevation = 0,
    this.focusElevation,
    this.highlightElevation,
    this.disabledElevation,
  }) : super(key: key);

  /// Called when the button has been pressed.
  final VoidCallback? onPressed;
  /// The child widget.
  final Widget label;
  /// The icon to display to the left of the child widget.
  final Widget? leadingIcon;
  /// The icon to display to the right of the child widget.
  final Widget? trailingIcon;
  /// The button color.
  final Color color;
  /// The button foreground color. Defaults to the CustomTheme primary color.
  final Color? foregroundColor;
  /// The disabled button color.
  final Color? disabledColor;
  /// The disabled button foreground color.
  final Color? disabledForegroundColor;
  /// The button border width. The [borderColor] property must also be set for a border to display.
  final double? borderWidth;
  /// The button border color. The [borderWidth] property must also be set for a border to display.
  final Color? borderColor;
  /// The disabled button border color.
  final Color? disabledBorderColor;
  /// The button's Material elevation.
  final double elevation;
  /// The elevation to use when the button is focused.
  final double? focusElevation;
  /// The elevation to use when the button is pressed.
  final double? highlightElevation;
  /// The elevation to use when the button is disabled.
  final double? disabledElevation;

  @override
  _PlatformButtonState createState() => _PlatformButtonState();
}

class _PlatformButtonState extends State<PlatformButton> {
  late bool _isPressed;
  late bool _isFocused;

  @override
  void initState() {
    super.initState();
    _isPressed = false;
    _isFocused = false;
  }

  bool get _isDisabled => widget.onPressed == null;

  /// Get the button color based on the current state.
  Color get _effectiveColor {
    if (_isDisabled) {
      return widget.disabledColor ?? widget.color;
    }
    return widget.color;
  }

  /// Get the foreground color based on the current state.
  Color? get _effectiveForegroundColor {
    if (_isDisabled) {
      return widget.disabledForegroundColor ?? widget.foregroundColor;
    }
    return widget.foregroundColor;
  }

  /// Gets the border color based on the current state.
  Color? get _effectiveBorderColor {
    if (_isDisabled) {
      return widget.disabledBorderColor ?? widget.borderColor;
    }
    return widget.borderColor;
  }

  /// Get the button elevation based on the current state.
  double get _effectiveElevation {
    if (_isDisabled) {
      return widget.disabledElevation ?? widget.elevation;
    } else if (_isPressed) {
      return widget.highlightElevation ?? widget.elevation;
    } else if (_isFocused) {
      return widget.focusElevation ?? widget.elevation;
    }
    return widget.elevation;
  }

  @override
  Widget build(BuildContext context) {
    // Get the target platform and effective style
    final bool isCupertino = Theme.of(context).platform == TargetPlatform.iOS;
    final Color color = _effectiveColor;
    final Color foregroundColor = _effectiveForegroundColor ?? CustomTheme.of(context).primary;
    // Build the button
    return PlatformTappable(
      onTap: widget.onPressed,
      color: color,
      splashColor: foregroundColor.withOpacity(0.12),
      elevation: _effectiveElevation,
      onFocusChanged: (focused) => setState(() => _isFocused = focused),
      onHighlightChanged: (pressed) => setState(() => _isPressed = pressed),
      constraints: isCupertino
        ? BoxConstraints(minWidth: 48.0, minHeight: 48.0)
        : BoxConstraints(minWidth: 88.0, minHeight: 36.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isCupertino ? 8.0 : 4.0),
        side: widget.borderColor != null && widget.borderWidth != null ? BorderSide(
          color: _effectiveBorderColor!,
          width: widget.borderWidth!,
        ) : BorderSide.none,
      ),
      child: childThemes(
        isCupertino: isCupertino,
        foregroundColor: foregroundColor,
        child: buttonContent(),
      ),
    );
  }

  /// Builds the text style and icon theme for the button children.
  Widget childThemes({
    required bool isCupertino, 
    required Color foregroundColor, 
    required Widget child
  }) => DefaultTextStyle(
    style: TextStyle(
      color: foregroundColor,
      fontSize: isCupertino ? 17.0 : 14.0,
      fontWeight: isCupertino ? null : FontWeight.w500,
      letterSpacing: isCupertino ? -0.4 : null,
    ),
    child: IconTheme(
      data: IconThemeData(
        color: foregroundColor
      ),
      child: child,
    ),
  );

  /// Builds the button content.
  Widget buttonContent() => Padding(
    padding: EdgeInsetsDirectional.only(
      start: widget.leadingIcon == null ? 16 : 12.0, 
      end: widget.trailingIcon == null ? 16 : 12.0,
    ),
    child: Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (widget.leadingIcon != null) ...[widget.leadingIcon!, const SizedBox(width: 8.0)],
          widget.label,
          if (widget.trailingIcon != null) ...[const SizedBox(width: 8.0), widget.trailingIcon!],
        ],
      ),
    ),
  );
}