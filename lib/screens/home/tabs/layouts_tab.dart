import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_experiments/widgets/navigation/custom_navigator.dart';

import '../../demos/layout_demos/fading_sliver_app_bar_demo.dart';
import '../../demos/layout_demos/fixed_bottom_sheet_demo.dart';
import '../../demos/layout_demos/platform_tab_bar_demo.dart';

class LayoutsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 6),
        Padding(
          child: Text(
            'FADING SLIVER APP BAR',
            style: Theme.of(context).textTheme.overline,
          ),
          padding: const EdgeInsets.only(top: 12.0, right: 16.0, bottom: 8.0, left: 16.0),
        ),
        ListTile(
          leading: const Icon(Icons.link),
          title: const Text('Pinned'),
          onTap: () => Navigator.push<Widget>(
              context,
              MaterialPageRoute(
                builder: (context) => const FadingSliverAppBarDemoScreen(pinned: true),
              )),
        ),
        ListTile(
          leading: const Icon(Icons.link_off),
          title: const Text('Floating'),
          onTap: () => Navigator.push<Widget>(
              context,
              MaterialPageRoute(
                builder: (context) => const FadingSliverAppBarDemoScreen(pinned: false),
              )),
        ),
        const Divider(),
        Padding(
          child: Text(
            'PLATFORM TAB BAR',
            style: Theme.of(context).textTheme.overline,
          ),
          padding: const EdgeInsets.only(top: 12.0, right: 16.0, bottom: 8.0, left: 16.0),
        ),
        ListTile(
          leading: const Icon(Icons.tab),
          title: const Text('Tabs'),
          onTap: () => Navigator.push<Widget>(
              context,
              MaterialPageRoute(
                builder: (context) => const PlatformTabBarDemoScreen(),
              )),
        ),
        ListTile(
          leading: const Icon(Icons.fast_forward_rounded),
          title: const Text('Scrolling Tabs'),
          onTap: () => Navigator.push<Widget>(
              context,
              MaterialPageRoute(
                builder: (context) => const PlatformTabBarDemoScreen(scrolling: true),
              )),
        ),
        const Divider(),
        Padding(
          child: Text(
            'FIXED BOTTOM SHEET PAGE',
            style: Theme.of(context).textTheme.overline,
          ),
          padding: const EdgeInsets.only(top: 12.0, right: 16.0, bottom: 8.0, left: 16.0),
        ),
        ListTile(
            leading: const Icon(Icons.call_to_action_outlined),
            title: const Text('Fixed Bottom Sheet With Buttons'),
            onTap: () => CustomNavigator.of(context).push(const FixedBottomSheetDemoScreen())),
      ],
    );
  }
}
