import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_experiments/theme/custom_theme.dart';
import 'package:flutter_experiments/widgets/controls/buttons/tap_target_padding.dart';

/// Creates a tappable surface that adapts to the current platform.
///
/// This is intended for custom platform-adaptive tappable widgets, such as buttons and cards,
/// that should visually respond to tap events appropriately depending on the platform.
///
/// On Android, an ink splash will be used to show the highlight state.
/// On iOS, the highlight state will be either change the button opacity or display the highlight
/// color, depending on the [cupertinoHighlightType] property.
class PlatformTappable extends StatefulWidget {
  const PlatformTappable({
    Key? key,
    required this.child,
    required this.onTap,
    this.onFocusChanged,
    this.onHighlightChanged,
    this.color,
    this.splashColor,
    this.focusColor,
    this.highlightColor,
    this.elevation,
    this.shape,
    this.cupertinoHighlightType = CupertinoHighlightType.Fade,
    this.constraints = const BoxConstraints(),
    this.minTapTargetSize = const Size(
      kMinInteractiveDimension,
      kMinInteractiveDimension,
    ),
  }) : super(key: key);

  /// The child widget.
  final Widget? child;

  /// Called when the button is pressed.
  final VoidCallback? onTap;

  /// Called when the focus state changes.
  final Function(bool value)? onFocusChanged;

  /// Called when the highlight state changes.
  final Function(bool value)? onHighlightChanged;

  /// The color for the tappable surface.
  final Color? color;

  /// The color to use for ink splashes. This applies to Android only.
  final Color? splashColor;

  /// The color to overlay when focused. Defaults to transparent.
  final Color? focusColor;

  /// The color to overlay when pressed. Defaults to transparent on Android, and
  /// CustomThemeData.highlight on iOS.
  final Color? highlightColor;

  /// The elevation for the button.
  final double? elevation;

  /// The tappable surface shape, including the border width, radius, and color.
  final ShapeBorder? shape;

  /// The highlight type to use on iOS.
  final CupertinoHighlightType cupertinoHighlightType;

  /// The minimum and maximum size constraints.
  final BoxConstraints constraints;

  /// The minimum tap target size for the button. Defaults to 44x44 on iOS, and 48x48 on Android.
  final Size? minTapTargetSize;

  @override
  _PlatformTappableState createState() => _PlatformTappableState();
}

class _PlatformTappableState extends State<PlatformTappable> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late bool _isPressed;

  @override
  void initState() {
    super.initState();
    _isPressed = false;
    _animationController = AnimationController(
      value: 0.0,
      duration: const Duration(milliseconds: 10),
      reverseDuration: const Duration(milliseconds: 100),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Calls [onHighlightChanged] and triggers the opacity animation on iOS.
  void _onHighlightChanged(bool isCupertino, bool isPressed) {
    widget.onHighlightChanged?.call(isPressed);
    if (isCupertino) {
      setState(() => _isPressed = isPressed);
      _cupertinoAnimate();
    }
  }

  /// Animates the button opacity on iOS.
  /// If the button is already animating, the animation shouldn't be interrupted.
  void _cupertinoAnimate() {
    if (!_animationController.isAnimating) {
      final TickerFuture animationTicker =
          _isPressed ? _animationController.forward() : _animationController.reverse();
      // When the animation ends, animate to the new state if the state has changed
      final bool wasPressed = _isPressed;
      animationTicker.then((_) {
        if (mounted && _isPressed != wasPressed) {
          _cupertinoAnimate();
        }
      });
    }
  }

  /// Gets the effective highlight color depending on the platform and cupertinoHighlightType.
  Color _getHighlightColor(BuildContext context, bool isCupertino) {
    if (isCupertino) {
      return widget.cupertinoHighlightType == CupertinoHighlightType.Color
          ? widget.highlightColor ?? CustomTheme.of(context).highlight
          : Colors.transparent;
    }
    return widget.highlightColor ?? Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    // Get the current platform
    final bool isCupertino = Theme.of(context).platform == TargetPlatform.iOS;
    // Create the button wrapped in Semantics and TapTargetPadding for accessibility
    final Widget button = Semantics(
      container: true,
      button: true,
      enabled: widget.onTap != null,
      child: TapTargetPadding(
        minSize: widget.minTapTargetSize,
        child: ConstrainedBox(
          constraints: widget.constraints,
          child: Material(
            elevation: widget.elevation ?? 0,
            color: widget.color,
            shape: widget.shape,
            child: InkWell(
              onTap: widget.onTap,
              onFocusChange: widget.onFocusChanged,
              onHighlightChanged: (highlighted) => _onHighlightChanged(isCupertino, highlighted),
              splashColor: isCupertino ? Colors.transparent : widget.splashColor,
              focusColor: widget.focusColor ?? Colors.transparent,
              highlightColor: _getHighlightColor(context, isCupertino),
              customBorder: widget.shape,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
    // Wrap the button in a FadeTransition if the platform is iOS
    return !isCupertino
        ? button
        : FadeTransition(
            child: button,
            opacity: _animationController
                .drive(CurveTween(curve: Curves.decelerate))
                .drive(Tween<double>(begin: 1.0, end: 0.4)),
          );
  }
}

/// The highlight type to use on iOS.
///
/// [Fade] will change the button opacity when highlighted.
/// [Color] will display the highlight color when highlighed.
enum CupertinoHighlightType { Fade, Color }
