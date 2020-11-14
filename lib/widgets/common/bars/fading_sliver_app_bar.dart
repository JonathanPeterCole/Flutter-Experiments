import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  FadingSliverAppBar({
    Key key,
    this.pinned = false,
    this.scrollController,
    this.backgroundColor,
    this.elevatedBackgroundColor,
    this.shadowColor,
    this.leading,
    this.title,
    this.actions,
    this.bottom,
    this.brightness,
    this.iconTheme,
    this.actionsIconTheme,
    this.textTheme,
    this.centerTitle
  }) : assert(
         !pinned || scrollController != null, 
         'If the AppBar is pinned, a scroll controller must be provided.'
       ),
       super(key: key);

  /// Whether or not the AppBar should stay fixed to the top of the screen or hide when scrolling.
  /// 
  /// If [true], the AppBar will stay fixed to the top of the screen when scrolling. 
  /// If [false], the AppBar will hide when scrolling down, and reappear when scrolling up.
  final bool pinned;

  /// The ScrollController for the parent ScrollView.
  /// 
  /// If the AppBar is pinned, the scroll controller is used to determine if the user has scrolled.
  final ScrollController scrollController;

  /// The background color to use when the AppBar is not overlapping the ScrollView content.
  final Color backgroundColor;

  /// The background color to use when the AppBar is overlapping the ScrollView content.
  final Color elevatedBackgroundColor;

  /// The shadow color.
  final Color shadowColor;

  /// A widget to display before the [title].
  final Widget leading;

  /// The primary widget displayed in the app bar.
  final Widget title;

  /// Widgets to display in a row after the [title] widget.
  final List<Widget> actions;

  /// This widget appears across the bottom of the app bar.
  final PreferredSizeWidget bottom;

  /// The brightness of the app bar's material.
  final Brightness brightness;

  /// The color, opacity, and size to use for app bar icons.
  final IconThemeData iconTheme;

  /// The color, opacity, and size to use for the icons that appear in the app bar's [actions].
  final IconThemeData actionsIconTheme;

  /// The typographic styles to use for text in the app bar.
  final TextTheme textTheme;

  /// Whether the title should be centered.
  final bool centerTitle;

  @override
  _FadingSliverAppBarState createState() => _FadingSliverAppBarState();
}

class _FadingSliverAppBarState extends State<FadingSliverAppBar> with TickerProviderStateMixin {

  /// Whether or not the AppBar should be elevated when pinned == true.
  bool _forceElevated;

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
  setupScrollListener() {
    if (widget.pinned) {
      widget.scrollController.addListener(onScrollEvent);
    } 
  }

  /// Handles scroll events to force elevation on scroll.
  onScrollEvent() {
    if (widget.scrollController.offset <= 0 && _forceElevated) {
      setState(() => _forceElevated = false);
    } else if (widget.scrollController.offset > 0 && !_forceElevated) {
      setState(() => _forceElevated = true);
    }
  }

  /// Builds the AppBar
  Widget buildAppBar(BuildContext context) => AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: widget.leading,
    title: widget.title,
    actions: widget.actions,
    bottom: widget.bottom,
    brightness: widget.brightness,
    iconTheme: widget.iconTheme,
    actionsIconTheme: widget.actionsIconTheme,
    textTheme: widget.textTheme,
    centerTitle: widget.centerTitle,
  );

  @override
  Widget build(BuildContext context) {
    // Get the top safe area padding
    final double topPadding = MediaQuery.of(context).padding.top;
    // Build the sliver
    return SliverPersistentHeader(
      pinned: widget.pinned,
      floating: !widget.pinned,
      delegate: _FadingSliverAppBarDelegate(
        pinned: widget.pinned,
        forceElevated: widget.pinned && _forceElevated,
        topPadding: topPadding,
        appBar: buildAppBar(context),
        backgroundColor: widget.backgroundColor
          ?? Theme.of(context).colorScheme.background,
        elevatedBackgroundColor: widget.elevatedBackgroundColor 
          ?? Theme.of(context).colorScheme.surface,
        shadowColor: Theme.of(context).appBarTheme.shadowColor,
      )
    );
  }
}

/// A SliverPersistentHeaderDelegate for displaying the AppBar as a sliver.  
/// 
/// To avoid rebuilding the AppBar during animation, the animation is applied to a Material widget,
/// and the AppBar is passed through the AnimationBuilder as the child.
class _FadingSliverAppBarDelegate extends SliverPersistentHeaderDelegate {

  _FadingSliverAppBarDelegate({
    this.pinned = false,
    this.forceElevated = false,
    this.topPadding = 0,
    @required this.appBar,
    @required this.backgroundColor,
    @required this.elevatedBackgroundColor,
    @required this.shadowColor,
  });

  /// Whether or not the appbar is pinned.
  final bool pinned;

  /// If the AppBar is pinned, this parameter determines if the AppBar should be elevated.
  final bool forceElevated;

  /// The SafeArea top padding.
  final double topPadding;

  /// The AppBar widget to display.
  final AppBar appBar;

  /// The background color to use when the AppBar is not overlapping the ScrollView content.
  final Color backgroundColor;

  /// The background color to use when the AppBar is overlapping the ScrollView content.
  final Color elevatedBackgroundColor;

  /// The shadow color.
  final Color shadowColor;
  
  @override
  double get minExtent => appBar.preferredSize.height + topPadding;

  @override
  double get maxExtent => appBar.preferredSize.height + topPadding;

  @override
  bool shouldRebuild(covariant _FadingSliverAppBarDelegate oldDelegate) => 
    forceElevated != oldDelegate.forceElevated ||
    appBar != oldDelegate.appBar ||
    backgroundColor != oldDelegate.backgroundColor ||
    elevatedBackgroundColor != oldDelegate.elevatedBackgroundColor ||
    shadowColor != oldDelegate.shadowColor;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ToggleAnimationBuilder(
      forwards: forceElevated || overlapsContent,
      duration: pinned ? Duration(milliseconds: 100) : Duration.zero,
      reverseDuration: Duration(milliseconds: 150),
      child: appBar,
      builder: (context, animationValue, child) => Material(
        child: child,
        elevation: 4,
        animationDuration: Duration.zero,
        color: ColorTween(begin: backgroundColor, end: elevatedBackgroundColor)
          .lerp(animationValue),
        shadowColor: ColorTween(begin: shadowColor.withOpacity(0), end: shadowColor)
          .lerp(animationValue),
      ),
    );
  }
}