import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../flows/demo/demo_flow.dart';

class ScreensTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 6),
        Padding(
          child: Text(
            'FLOW DEMO',
            style: Theme.of(context).textTheme.overline,
          ),
          padding: const EdgeInsets.only(top: 12.0, right: 16.0, bottom: 8.0, left: 16.0),
        ),
        ListTile(
          leading: const Icon(Icons.amp_stories_rounded),
          title: const Text('Demo Flow'),
          onTap: () {
            DemoFlow().start(context);
          },
        ),
        const Divider(),
      ],
    );
  }
}
