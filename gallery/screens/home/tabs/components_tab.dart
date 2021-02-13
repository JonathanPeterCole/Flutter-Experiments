import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_experiments/widgets/common/controls/buttons/outlined_platform_button.dart';
import 'package:flutter_experiments/widgets/common/controls/buttons/contained_button.dart';
import 'package:flutter_experiments/widgets/common/controls/buttons/text_platform_button.dart';

class ComponentsTab extends StatefulWidget {
  @override
  _ComponentsTabState createState() => _ComponentsTabState();
}

class _ComponentsTabState extends State<ComponentsTab> {
  bool showLoading = false;

  void toggleLoading() {
    setState(() => showLoading = true);
    Future<void>.delayed(const Duration(seconds: 3), () => setState(() => showLoading = false));
  }

  @override
  Widget build(BuildContext context) => ListView(
        children: [
          const SizedBox(height: 6),
          Padding(
            child: Text(
              'BUTTONS',
              style: Theme.of(context).textTheme.overline,
            ),
            padding: const EdgeInsets.only(top: 12.0, right: 16.0, bottom: 8.0, left: 16.0),
          ),
          ListTile(
            title: ContainedPlatformButton(
              label: const Text('Contained'),
              onPressed: toggleLoading,
              loading: showLoading,
            ),
          ),
          const ListTile(
            title: ContainedPlatformButton(
              label: Text('Contained Disabled'),
              onPressed: null,
            ),
          ),
          ListTile(
            title: OutlinedPlatformButton(
              label: const Text('Outlined'),
              onPressed: toggleLoading,
              loading: showLoading,
            ),
          ),
          const ListTile(
            title: OutlinedPlatformButton(
              label: Text('Outlined Disabled'),
              onPressed: null,
            ),
          ),
          ListTile(
            title: TextPlatformButton(
              label: const Text('Text'),
              onPressed: toggleLoading,
              loading: showLoading,
            ),
          ),
          const ListTile(
            title: TextPlatformButton(
              label: Text('Text Disabled'),
              onPressed: null,
            ),
          ),
          const Divider(),
        ],
      );
}
