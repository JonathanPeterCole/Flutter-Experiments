import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../screens/layout_demos/fading_sliver_app_bar_demo.dart';

class LayoutsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListView(
    children: [
      ListTile(
        title: Text('FadingSliverAppBar',
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ),
      ListTile(
        leading: Icon(Icons.link),
        title: Text('Pinned'),
        onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (context) => FadingSliverAppBarDemoScreen(pinned: true),
        )),
      ),
      ListTile(
        leading: Icon(Icons.link_off),
        title: Text('Floating'),
        onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (context) => FadingSliverAppBarDemoScreen(pinned: false),
        )),
      ),
      Divider(),
    ],
  );
}