import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_experiments/widgets/bars/platform_app_bar.dart';
import 'package:flutter_experiments/widgets/bars/platform_tab_bar.dart';

class PlatformTabBarDemoScreen extends StatelessWidget {
  const PlatformTabBarDemoScreen({
    Key? key,
    this.scrolling = false,
  }) : super(key: key);

  final bool scrolling;

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: scrolling ? 8 : 3,
        child: Scaffold(
          appBar: PlatformAppBar(
            context,
            centerTitle: true,
            title: const Text('Tabs Demo'),
            bottom: PlatformTabBar(
              scrolling: scrolling,
              tabs: [
                const Tab(text: 'First'),
                const Tab(text: 'Second'),
                const Tab(text: 'Third'),
                if (scrolling) ...[
                  const Tab(text: 'Fourth'),
                  const Tab(text: 'Fith'),
                  const Tab(text: 'Sixth'),
                  const Tab(text: 'Seventh'),
                  const Tab(text: 'Eighth'),
                ]
              ],
            ),
          ),
          body: TabBarView(
            children: [
              const Icon(Icons.directions_car),
              const Icon(Icons.directions_transit),
              const Icon(Icons.directions_bike),
              if (scrolling) ...[
                const Icon(Icons.directions_car),
                const Icon(Icons.directions_transit),
                const Icon(Icons.directions_bike),
                const Icon(Icons.directions_car),
                const Icon(Icons.directions_transit),
              ]
            ],
          ),
        ),
      );
}
