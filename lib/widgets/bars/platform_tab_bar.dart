import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_experiments/theme/custom_theme.dart';

/// A custom tab bar that uses a standard Material tab indicator on Android, and a bubble
/// indicator style on iOS.
class PlatformTabBar extends StatelessWidget implements PreferredSizeWidget {
  const PlatformTabBar({
    Key? key,
    this.controller,
    this.scrolling = false,
    required this.tabs,
  }) : super(key: key);

  final TabController? controller;
  final bool scrolling;
  final List<Widget> tabs;

  @override
  Size get preferredSize => const Size.fromHeight(48);

  @override
  Widget build(BuildContext context) {
    final bool isCupertino = Theme.of(context).platform == TargetPlatform.iOS;
    return TabBar(
      controller: controller,
      isScrollable: scrolling,
      labelPadding: scrolling && isCupertino ? const EdgeInsets.symmetric(horizontal: 20) : null,
      indicator: isCupertino
          ? CupertinoTabIndicator(color: CustomTheme.of(context).background, scrolling: scrolling)
          : null,
      indicatorColor: CustomTheme.of(context).textPrimary,
      indicatorSize: scrolling && isCupertino ? TabBarIndicatorSize.label : TabBarIndicatorSize.tab,
      tabs: tabs,
    );
  }
}

/// An alternate indicator style for iOS devices.
/// Inspired by https://pub.dev/packages/bubble_tab_indicator
class CupertinoTabIndicator extends Decoration {
  const CupertinoTabIndicator({
    required this.color,
    required this.scrolling,
  });

  final Color color;
  final bool scrolling;

  @override
  _CupertinoTabIndicatorPainter createBoxPainter([VoidCallback? onChanged]) =>
      _CupertinoTabIndicatorPainter(this, onChanged);
}

class _CupertinoTabIndicatorPainter extends BoxPainter {
  _CupertinoTabIndicatorPainter(this.decoration, VoidCallback? onChanged) : super(onChanged);

  final CupertinoTabIndicator decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    // Get the indicator size
    final Rect indicatorSize =
        Offset(offset.dx, configuration.size!.height / 2) & Size(configuration.size!.width, 0);
    final double horizontalPadding = decoration.scrolling ? 10 : -12;
    final Rect paddedIndicatorSize =
        EdgeInsets.only(top: 14, right: horizontalPadding, bottom: 12, left: horizontalPadding)
            .inflateRect(indicatorSize);
    // Get the paint style
    final Paint paint = Paint()
      ..color = decoration.color
      ..style = PaintingStyle.fill;
    // Draw the indicator
    canvas.drawRRect(
        RRect.fromRectAndRadius(paddedIndicatorSize, const Radius.circular(100)), paint);
  }
}
