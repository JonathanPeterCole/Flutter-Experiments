import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_experiments/widgets/common/bars/platform_app_bar.dart';
import 'package:flutter_experiments/widgets/common/bars/platform_tab_bar.dart';

class PlatformTabBarDemoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: PlatformAppBar(
            context,
            centerTitle: true,
            title: const Text('Tabs Demo'),
            bottom: const PlatformTabBar(tabs: [
              Tab(text: 'Test 1'),
              Tab(text: 'Test 2'),
              Tab(text: 'Test 3'),
            ]),
          ),
          body: const TabBarView(
            physics: BouncingScrollPhysics(),
            children: [
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      );
}
