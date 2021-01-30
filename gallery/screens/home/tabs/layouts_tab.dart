import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../demos/layout_demos/fading_sliver_app_bar_demo.dart';

class LayoutsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListView(
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
        ],
      );
}
