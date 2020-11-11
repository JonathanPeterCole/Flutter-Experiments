import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../layout_demos/fading_sliver_app_bar_demo.dart';

class LayoutsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListView(
    children: [
      SizedBox(height: 6),
      Padding(
        child: Text('FADING SLIVER APP BAR',
          style: Theme.of(context).textTheme.overline,
        ),
        padding: EdgeInsets.only(top: 12.0, right: 16.0, bottom: 8.0, left: 16.0),
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