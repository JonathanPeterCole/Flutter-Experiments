import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// A custom Bottom Navigation Bar that adapts to the platform.
///
/// Displays a Material BottomNavigationBar on Android, and a CupertinoTabBar on iOS.
class PlatformBottomNavigationBar extends StatelessWidget {
  const PlatformBottomNavigationBar({
    Key? key,
    this.currentIndex = 0,
    required this.items,
    required this.onTap,
  }) : super(key: key);

  /// The selected bottom nav index.
  final int currentIndex;

  /// The bottom nav items to display.
  final List<BottomNavigationBarItem> items;

  /// The on item tap callback.
  final Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    // Get the bottom nav bar for the platform.
    final bool isCupertino = Theme.of(context).platform == TargetPlatform.iOS;
    final Widget bottomNavBar = isCupertino
        ? CupertinoTabBar(
            currentIndex: currentIndex,
            items: items,
            onTap: onTap,
          )
        : BottomNavigationBar(
            currentIndex: currentIndex,
            items: items,
            onTap: onTap,
          );
    // The Material BottomNavigationBar currently subtracts half the selected label size from the
    // safe area inset padding, which is incorrect behaviour for Android. As a temporary fix,
    // increase the safe area inset padding.
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final bool shouldOverridePadding = !isCupertino && mediaQueryData.padding.bottom > 0;
    if (shouldOverridePadding) {
      return MediaQuery(
        data: mediaQueryData.copyWith(
          padding: EdgeInsets.only(bottom: mediaQueryData.padding.bottom + 7.0),
        ),
        child: bottomNavBar,
      );
    }
    // Return nav bar on its own when running on iOS or an Android device with no bottom inset.
    return bottomNavBar;
  }
}
