import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_experiments/theme/custom_theme.dart';
import 'package:flutter_experiments/widgets/common/animation/toggle_animation_builder.dart';

/// A custom Sliver AppBar that blends in with the page background until the user scrolls.
///
/// By default, the AppBar will hide when the user scrolls. To change this, set [pinned] to true.
class FadingSliverAppBar extends StatelessWidget {
  const FadingSliverAppBar({
    Key? key,
    this.pinned = false,
    this.title,
    this.actions,
    this.backgroundColor,
    this.elevatedBackgroundColor,
    this.backButtonText,
    this.centerTitle,
  }) : super(key: key);

  /// Whether or not the AppBar should stay fixed to the top of the screen or hide when scrolling.
  ///
  /// If [true], the AppBar will stay fixed to the top of the screen when scrolling.
  /// If [false], the AppBar will hide when scrolling down, and reappear when scrolling up.
  final bool pinned;

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

  @override
  Widget build(BuildContext context) {
    // Get the current platform
    final bool isCupertino = Theme.of(context).platform == TargetPlatform.iOS;
    // Get the safe area padding and AppBar height
    final double topPadding = MediaQuery.of(context).padding.top;
    final double appBarHeight = isCupertino ? kMinInteractiveDimensionCupertino : kToolbarHeight;
    // Get the background and shadow colors
    final Color effectiveColor = backgroundColor ?? CustomTheme.of(context).background;
    final Color effectiveElevatedColor = elevatedBackgroundColor ?? CustomTheme.of(context).surface;
    final Color shadowColor = CustomTheme.of(context).shadow;
    // Build the sliver
    return SliverPersistentHeader(
      pinned: pinned,
      floating: !pinned,
      delegate: _FadingSliverAppBarDelegate(
        pinned: pinned,
        height: topPadding + appBarHeight,
        appBarBuilder: (animationValue) {
          // Get the colors based on the animation value
          final Color? animatedBackgroundColor = ColorTween(
            begin: effectiveColor,
            end: effectiveElevatedColor,
          ).lerp(animationValue);
          final Color? animatedShadowColor = ColorTween(
            begin: shadowColor.withOpacity(0),
            end: shadowColor,
          ).lerp(animationValue);
          // Build the app bar
          return isCupertino
              ? buildCupertinoAppbar(
                  context: context,
                  backgroundColor: animatedBackgroundColor!,
                )
              : buildMaterialAppbar(
                  backgroundColor: animatedBackgroundColor!,
                  shadowColor: animatedShadowColor!,
                );
        },
      ),
    );
  }

  /// Builds the AppBar for Android.
  ///
  /// The background color and elevation are applied to a PhysicalModel widget which wraps a
  /// transparent AppBar, as the AppBar widget applies its own animation to these properties which
  /// cannot be disabled.
  Widget buildMaterialAppbar({
    required Color backgroundColor,
    required Color shadowColor,
  }) =>
      PhysicalModel(
        elevation: 4,
        color: backgroundColor,
        shadowColor: shadowColor,
        child: AppBar(
          title: title,
          actions: actions,
          backgroundColor: Colors.transparent,
          centerTitle: centerTitle,
          elevation: 0,
        ),
      );

  /// Builds the AppBar for iOS.
  ///
  /// The background color is applied directly to the CupertinoNavigationBar, as making the bar
  /// transparent results in a background blur effect that cannot be disabled.
  Widget buildCupertinoAppbar({
    required BuildContext context,
    required Color backgroundColor,
  }) =>
      CupertinoNavigationBar(
        middle: title,
        trailing: actions != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: actions!,
              )
            : null,
        border: Border.all(style: BorderStyle.none),
        backgroundColor: backgroundColor,
      );
}

/// A SliverPersistentHeaderDelegate for displaying the AppBar as a sliver.
class _FadingSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _FadingSliverAppBarDelegate({
    this.pinned = false,
    required this.height,
    required this.appBarBuilder,
  });

  /// Whether or not the appbar is pinned.
  final bool pinned;

  /// The AppBar height including safe area padding.
  final double height;

  /// The function to build the app bar with the elevation animation value.
  final Widget Function(double animationValue) appBarBuilder;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  bool shouldRebuild(covariant _FadingSliverAppBarDelegate oldDelegate) => true;

  /// Build the sliver app bar and animate the style depending on whether or not it should be
  /// elevated.
  ///
  /// If the sliver is pinned, [shrinkOffset] is used instead of [overlapsContent] to determine if
  /// the app bar should be elevated, as [overlapsContent] is always false when pinned:
  /// https://github.com/flutter/flutter/issues/26667
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) =>
      ToggleAnimationBuilder(
        forwards: overlapsContent || (pinned && shrinkOffset > 0),
        duration: pinned ? const Duration(milliseconds: 100) : Duration.zero,
        reverseDuration: const Duration(milliseconds: 150),
        builder: (context, animationValue, child) => appBarBuilder(animationValue),
      );
}
