import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A custom version of Flutter's CupertinoActivityIndicator with support custom colors.
///
/// Unlike the standard Flutter CupertinoActivityIndicator, this version supports custom colors and
/// can be sized using SizedBox, matching the Material CircularProgressIndicator.
class CustomCupertinoActivityIndicator extends StatefulWidget {
  const CustomCupertinoActivityIndicator({
    Key? key,
    this.color,
  }) : super(key: key);

  /// Sets a custom spinner color.
  final Color? color;

  @override
  _CustomCupertinoActivityIndicatorState createState() => _CustomCupertinoActivityIndicatorState();
}

class _CustomCupertinoActivityIndicatorState extends State<CustomCupertinoActivityIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getDefaultColor(BuildContext context) => Theme.of(context).brightness == Brightness.light
      ? const Color(0xFF3C3C44).withOpacity(0.58)
      : const Color(0xFFEBEBF5).withOpacity(0.58);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CupertinoActivityIndicatorPainter(
        animation: _controller,
        activeColor: widget.color ?? _getDefaultColor(context),
      ),
    );
  }
}

class _CupertinoActivityIndicatorPainter extends CustomPainter {
  _CupertinoActivityIndicatorPainter({
    required this.animation,
    required this.activeColor,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color activeColor;

  @override
  void paint(Canvas canvas, Size size) {
    const int tickCount = 8;
    // Get the radius and tick weight based on the size
    final double radius = size.height / 2.0;
    final double weight = radius / 5;
    // Set the positions of each side of the tick, relative to the center of the spinner
    final RRect tickRRect = RRect.fromLTRBR(
      -(weight / 2),
      -radius,
      weight / 2,
      -radius / 3.0,
      Radius.circular(weight / 2),
    );
    // Prepare tick color tween sequence
    final TweenSequence<double> tweenSequence = TweenSequence([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1, end: 0.32).chain(CurveTween(curve: Curves.ease)),
        weight: 60,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.32, end: 0.32),
        weight: 20,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.32, end: 1).chain(CurveTween(curve: Curves.ease)),
        weight: 20,
      ),
    ]);
    // Draw the ticks
    final Paint paint = Paint();
    canvas.save();
    canvas.translate(size.width / 2.0, size.height / 2.0);
    for (int i = 0; i < tickCount; ++i) {
      // Offset the animation for each tick
      double offsetAnimationVal = animation.value - (i * (1 / tickCount));
      if (offsetAnimationVal < 0) {
        offsetAnimationVal = offsetAnimationVal + 1;
      }
      // Draw the tick
      paint.color = activeColor
          .withOpacity(activeColor.opacity * tweenSequence.transform(offsetAnimationVal));
      canvas.drawRRect(tickRRect, paint);
      canvas.rotate((math.pi * 2.0) / tickCount);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_CupertinoActivityIndicatorPainter oldPainter) =>
      oldPainter.animation != animation || oldPainter.activeColor != activeColor;
}
