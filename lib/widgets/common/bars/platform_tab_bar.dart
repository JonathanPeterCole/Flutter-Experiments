import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_experiments/theme/custom_theme.dart';

/// A custom tab bar that uses a standard Material tab indicator on Android, and a bubble
/// indicator style on iOS.
class PlatformTabBar extends StatelessWidget implements PreferredSizeWidget {
  const PlatformTabBar({
    Key? key,
    this.controller,
    required this.tabs,
  }) : super(key: key);

  final TabController? controller;
  final List<Widget> tabs;

  @override
  Size get preferredSize => const Size.fromHeight(48);

  @override
  Widget build(BuildContext context) {
    final bool isCupertino = Theme.of(context).platform == TargetPlatform.iOS;
    return TabBar(
      controller: controller,
      indicator:
          isCupertino ? CupertinoTabIndicator(color: CustomTheme.of(context).background) : null,
      indicatorSize: isCupertino ? TabBarIndicatorSize.label : TabBarIndicatorSize.tab,
      tabs: tabs,
    );
  }
}

/// An alternate indicator style for iOS devices.
/// Inspired by https://pub.dev/packages/bubble_tab_indicator
class CupertinoTabIndicator extends Decoration {
  const CupertinoTabIndicator({
    required this.color,
  });

  final Color color;

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
    final Rect paddedIndicatorSize =
        const EdgeInsets.only(top: 16, right: 12, bottom: 14, left: 12).inflateRect(indicatorSize);
    // Get the paint style
    final Paint paint = Paint()
      ..color = decoration.color
      ..style = PaintingStyle.fill;
    // Draw the indicator
    canvas.drawRRect(
        RRect.fromRectAndRadius(paddedIndicatorSize, const Radius.circular(100)), paint);
  }
}
