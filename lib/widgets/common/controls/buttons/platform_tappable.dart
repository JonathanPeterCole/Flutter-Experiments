import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_experiments/widgets/common/controls/buttons/tap_target_padding.dart';

/// Creates a tappable surface that adapts to the current platform.
/// 
/// This is intended for custom platform-adaptive tappable widgets, such as buttons and cards, 
/// that should visually respond to tap events appropriately depending on the platform.
/// 
/// On Android, an ink splash will be used to show the highlight state.
/// On iOS, the opacity will change to show the pressed state.
class PlatformTappable extends StatefulWidget {

  const PlatformTappable({
    Key? key,
    required this.child,
    required this.onTap,
    this.onFocusChanged,
    this.onHighlightChanged,
    this.color,
    this.splashColor,
    this.elevation,
    this.shape,
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
  /// The elevation for the button.
  final double? elevation;
  /// The tappable surface shape, including the border width, radius, and color.
  final ShapeBorder? shape;
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
      final TickerFuture animationTicker = _isPressed
        ? _animationController.forward()
        : _animationController.reverse();
      // When the animation ends, animate to the new state if the state has changed
      bool wasPressed = _isPressed;
      animationTicker.then((void _) {
        if (mounted && _isPressed != wasPressed) {
          _cupertinoAnimate();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current platform
    bool isCupertino = Theme.of(context).platform == TargetPlatform.iOS;
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
              highlightColor: Colors.transparent,
              customBorder: widget.shape,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
    // Wrap the button in a FadeTransition if the platform is iOS
    return !isCupertino ? button : FadeTransition(
      child: button,
      opacity: _animationController
        .drive(CurveTween(curve: Curves.decelerate))
        .drive(Tween<double>(begin: 1.0, end: 0.4)),
    );
  } 
}
