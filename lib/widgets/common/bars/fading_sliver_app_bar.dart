import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_experiments/theme/custom_theme.dart';
import 'package:flutter_experiments/widgets/common/animation/toggle_animation_builder.dart';

/// A custom Sliver AppBar that blends in with the page background until the user scrolls.
/// 
/// By default, the AppBar will hide when the user scrolls. To change this, set [pinned] to true,
/// and pass in the scroll controller used by the parent [CustomScrollView]. If the scroll view is
/// using the primary scroll controller, you can get it in the same build method as the Scaffold by
/// using [Builder]:
/// ```
/// @override
/// Widget build(BuildContext context) => Scaffold(
///   body: Builder(
///     builder: (context) => CustomScrollView(
///       primary: true,
///       slivers: [
///         FadingSliverAppBar(
///           pinned: true,
///           scrollController: PrimaryScrollController.of(context),
///           title: Text('Hello World'),
///         ),
///         // Screen Contents
///       ],
///     ),
///   ),
/// );
/// ```
class FadingSliverAppBar extends StatefulWidget {

  FadingSliverAppBar(BuildContext context, {
    Key? key,
    this.pinned = false,
    this.scrollController,
    this.title,
    this.actions,
    this.backgroundColor,
    this.elevatedBackgroundColor,
    this.backButtonText,
    this.centerTitle,
  }) : assert(
         !pinned || scrollController != null, 
         'If the AppBar is pinned, a scroll controller must be provided.'
       ),
       platform = Theme.of(context).platform,
       super(key: key);

  /// Whether or not the AppBar should stay fixed to the top of the screen or hide when scrolling.
  /// 
  /// If [true], the AppBar will stay fixed to the top of the screen when scrolling. 
  /// If [false], the AppBar will hide when scrolling down, and reappear when scrolling up.
  final bool pinned;

  /// The ScrollController for the parent ScrollView.
  /// 
  /// If the AppBar is pinned, the scroll controller is used to determine if the user has scrolled.
  final ScrollController? scrollController;

  /// The primary widget displayed in the app bar.
  final Widget? title;

  /// Widgets to display in a row after the [title] widget.
  final List<Widget>? actions;

  /// The background color to use when the AppBar is not overlapping the ScrollView content.
  final Color? backgroundColor;

  /// The background color to use when the AppBar is overlapping the ScrollView content.
  final Color? elevatedBackgroundColor;

  /// The text to display next to the back button.
  /// Only applies to iOS.
  final String? backButtonText;

  /// Whether or not the title should be centered.
  /// Only applies to Android. On iOS this will always be true.
  final bool? centerTitle;

  /// The current platform.
  final TargetPlatform platform;

  @override
  _FadingSliverAppBarState createState() => _FadingSliverAppBarState();
}

class _FadingSliverAppBarState extends State<FadingSliverAppBar> with TickerProviderStateMixin {

  /// Whether or not the AppBar should be elevated when pinned == true.
  bool _forceElevated = false;

  @override
  void initState() {
    super.initState();
    _forceElevated = false;
    setupScrollListener();
  }

  @override
  void didUpdateWidget(FadingSliverAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.scrollController?.removeListener(onScrollEvent);
    setupScrollListener();
  }

  @override
  void dispose() {
    super.dispose();
    widget.scrollController?.removeListener(onScrollEvent);
  }

  /// Adds the scroll event listener if the AppBar is pinned.
  void setupScrollListener() {
    if (widget.pinned) {
      widget.scrollController!.addListener(onScrollEvent);
    } 
  }

  /// Handles scroll events to force elevation on scroll.
  void onScrollEvent() {
    if (widget.scrollController!.offset <= 0 && _forceElevated) {
      setState(() => _forceElevated = false);
    } else if (widget.scrollController!.offset > 0 && !_forceElevated) {
      setState(() => _forceElevated = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the safe area padding and AppBar height
    final double topPadding = MediaQuery.of(context).padding.top;
    final double appBarHeight = widget.platform == TargetPlatform.android ? kToolbarHeight
      : kMinInteractiveDimensionCupertino;
    // Get the background and shadow colors
    final Color backgroundColor = widget.backgroundColor ?? CustomTheme.of(context).background;
    final Color elevatedBackgroundColor = widget.elevatedBackgroundColor
      ?? CustomTheme.of(context).surface;
    final Color shadowColor = CustomTheme.of(context).shadow;
    // Build the sliver
    return SliverPersistentHeader(
      pinned: widget.pinned,
      floating: !widget.pinned,
      delegate: _FadingSliverAppBarDelegate(
        pinned: widget.pinned,
        forceElevated: widget.pinned && _forceElevated,
        height: topPadding + appBarHeight,
        appBarBuilder: (animationValue) => 
          widget.platform == TargetPlatform.android ? buildMaterialAppbar(
            animationValue: animationValue,
            backgroundColor: backgroundColor,
            elevatedBackgroundColor: elevatedBackgroundColor,
            shadowColor: shadowColor,
          ) : buildCupertinoAppbar(
            animationValue: animationValue,
            backgroundColor: backgroundColor,
            elevatedBackgroundColor: elevatedBackgroundColor,
          )
      )
    );
  }

  /// Builds the AppBar for Android.
  /// 
  /// The background color and elevation are applied to a Material widget which wraps a transparent
  /// AppBar, as the AppBar widget applies its own animation to these properties which cannot be
  /// disabled.
  Widget buildMaterialAppbar({
    required double animationValue, 
    required Color backgroundColor, 
    required Color elevatedBackgroundColor, 
    required Color shadowColor,
  }) => Material(
    animationDuration: Duration.zero,
    elevation: 4,
    color: ColorTween(begin: backgroundColor, end: elevatedBackgroundColor)
      .lerp(animationValue),
    shadowColor: ColorTween(begin: shadowColor.withOpacity(0), end: shadowColor)
      .lerp(animationValue),
    child: AppBar(
      title: widget.title,
      actions: widget.actions,
      backgroundColor: Colors.transparent,
      centerTitle: widget.centerTitle,
      elevation: 0,
    ),
  );

  /// Builds the AppBar for iOS.
  /// 
  /// The background color is applied directly to the CupertinoNavigationBar, with transparency
  /// only being applied when elevated to prevent the blur effect being applied when the bar is
  /// not overlaying any content.
  Widget buildCupertinoAppbar({
    required double animationValue, 
    required Color backgroundColor, 
    required Color elevatedBackgroundColor,
  }) => CupertinoNavigationBar(
      middle: widget.title,
      trailing: widget.actions != null ? Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widget.actions!,
      ) : null,
      actionsForegroundColor: CustomTheme.of(context).primary,
      border: Border.all(style: BorderStyle.none),
      backgroundColor: ColorTween(
        begin: backgroundColor, 
        end: elevatedBackgroundColor.withOpacity(0.8)
      ).lerp(animationValue),
  );
}

/// A SliverPersistentHeaderDelegate for displaying the AppBar as a sliver.
class _FadingSliverAppBarDelegate extends SliverPersistentHeaderDelegate {

  _FadingSliverAppBarDelegate({
    this.pinned = false,
    this.forceElevated = false,
    required this.height,
    required this.appBarBuilder,
  });

  /// Whether or not the appbar is pinned.
  final bool pinned;

  /// If the AppBar is pinned, this parameter determines if the AppBar should be elevated.
  final bool forceElevated;

  /// The AppBar height including safe area padding.
  final double height;

  final Widget Function(double animationValue) appBarBuilder;
  
  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  bool shouldRebuild(covariant _FadingSliverAppBarDelegate oldDelegate) => true;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ToggleAnimationBuilder(
      forwards: forceElevated || overlapsContent,
      duration: pinned ? const Duration(milliseconds: 100) : Duration.zero,
      reverseDuration: const Duration(milliseconds: 150),
      builder: (context, animationValue, child) => appBarBuilder(animationValue)
    );
  }
}