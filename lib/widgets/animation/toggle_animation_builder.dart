import 'package:flutter/widgets.dart';

/// An animation builder that allows for animating between two states using a toggle.
/// 
/// ```
/// @override
/// Widget build(BuildContext context) => ToggleAnimationBuilder(
///   forwards: shouldBeBlue,
///   duration: Duration(milliseconds: 300),
///   child: expensiveChildWidget,
///   builder: (context, animationValue, child) => Container(
///     color: ColorTween(begin: Colors.red, end: Colors.blue).lerp(animationValue),
///     child: child,
///   ),
/// );
/// ```
class ToggleAnimationBuilder extends StatefulWidget {

  const ToggleAnimationBuilder({
    Key? key,
    this.forwards = false,
    required this.duration,
    this.reverseDuration,
    this.child,
    required this.builder,
  }) : super(key: key);

  /// If true, the animation value will be 1.0, otherwise it will be 0.0.  
  /// 
  /// If this parameter changes whilst the widget is in the tree, the ToggleAnimationBuilder will
  /// animate to the new value.
  final bool forwards;

  /// The animation duration.
  final Duration duration;

  /// The optional reverse duration. If none is given, the [duration] parameter will be used 
  /// instead.
  final Duration? reverseDuration;

  /// The optional child widget.
  /// 
  /// Use this to improve performance if you have a child widget that doesn't need to be rebuilt
  /// when the animation value changes.
  final Widget? child;

  /// Called when the animation value changes.
  final Widget Function(BuildContext context, double animationValue, Widget? child) builder;

  @override
  _ToggleAnimationBuilderState createState() => _ToggleAnimationBuilderState();
}

class _ToggleAnimationBuilderState extends State<ToggleAnimationBuilder>
  with TickerProviderStateMixin {

  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      value: widget.forwards ? 1 : 0,
      duration: widget.duration,
      reverseDuration: widget.reverseDuration
    );
  }

  @override
  void didUpdateWidget(ToggleAnimationBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the durations
    _controller?.duration = widget.duration;
    _controller?.reverseDuration = widget.reverseDuration;
    // Animate if the forwards parameter has changed
    if (widget.forwards != oldWidget.forwards) {
      if (widget.forwards) {
        _controller?.forward();
      } else {
        _controller?.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller!,
    child: widget.child,
    builder: (context, child) => widget.builder(context, _controller!.value, child),
  );
}