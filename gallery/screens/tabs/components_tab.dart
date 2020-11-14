import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_experiments/widgets/common/controls/buttons/platform_button.dart';

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
        title: PlatformButton(
          child: Text('Primary'),
          onPressed: () {},
        ),
      ),
      ListTile(
        title: PlatformButton(
          child: Text('Primary Disabled'),
        ),
      ),
      ListTile(
        title: PlatformButton(
          child: Text('Primary Danger'),
          onPressed: () {},
          danger: true,
        ),
      ),
      ListTile(
        title: PlatformButton(
          child: Text('Primary Danger Disabled'),
          danger: true,
        ),
      ),
      ListTile(
        title: PlatformButton(
          child: Text('Secondary'),
          onPressed: () {},
          type: PlatformButtonType.Secondary
        ),
      ),
      ListTile(
        title: PlatformButton(
          child: Text('Secondary Danger'),
          onPressed: () {},
          danger: true,
          type: PlatformButtonType.Secondary
        ),
      ),
      ListTile(
        title: PlatformButton(
          child: Text('Secondary Disabled'),
          type: PlatformButtonType.Secondary
        ),
      ),
      Divider(),
    ],
  );
}