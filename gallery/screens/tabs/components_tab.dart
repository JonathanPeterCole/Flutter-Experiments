import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_experiments/widgets/common/controls/buttons/outlined_platform_button.dart';
import 'package:flutter_experiments/widgets/common/controls/buttons/contained_button.dart';
import 'package:flutter_experiments/widgets/common/controls/buttons/text_platform_button.dart';

class ComponentsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListView(
    children: [
      SizedBox(height: 6),
      Padding(
        child: Text('BUTTONS',
          style: Theme.of(context).textTheme.overline,
        ),
        padding: EdgeInsets.only(top: 12.0, right: 16.0, bottom: 8.0, left: 16.0),
      ),
      ListTile(
        title: ContainedPlatformButton(
          label: Text('Contained'),
          onPressed: () {},
        ),
      ),
      ListTile(
        title: ContainedPlatformButton(
          label: Text('Contained Disabled'),
          onPressed: null,
        ),
      ),
      ListTile(
        title: OutlinedPlatformButton(
          label: Text('Outlined'),
          onPressed: () {},
        ),
      ),
      ListTile(
        title: OutlinedPlatformButton(
          label: Text('Outlined Disabled'),
          onPressed: null,
        ),
      ),
      ListTile(
        title: TextPlatformButton(
          label: Text('Text'),
          onPressed: () {},
        ),
      ),
      ListTile(
        title: TextPlatformButton(
          label: Text('Text Disabled'),
          onPressed: null,
        ),
      ),
      Divider(),
    ],
  );
}