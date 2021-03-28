import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_experiments/theme/custom_theme.dart';
import 'package:flutter_experiments/widgets/bars/fading_sliver_app_bar.dart';
import 'package:flutter_experiments/widgets/scrolling/sliver_sticky_bottom_builder.dart';

class SliverStickyBottomBuilderDemoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        primary: true,
        slivers: [
          const FadingSliverAppBar(
            title: Text('SliverStickyBottom Demo'),
            centerTitle: true,
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 1000,
              color: Colors.redAccent,
              alignment: Alignment.center,
              child: const Text('Leading Sliver'),
            ),
          ),
          SliverStickyBottomBuilder(
            child: Container(
              height: 2000,
              color: Colors.purple,
              child: const Placeholder(),
            ),
            bottomBuilder: (context, sizeOffset, scrollOffset) => Container(
              color: CustomTheme.of(context).surface,
              alignment: Alignment.topCenter,
              child: LinearProgressIndicator(value: scrollOffset),
            ),
            bottomExtent: 4,
            stuckBottomExtent: 4 + MediaQuery.of(context).padding.bottom,
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 1000,
              color: Colors.redAccent,
              alignment: Alignment.center,
              child: const Text('Trailing Sliver'),
            ),
          ),
        ],
      ),
    );
  }
}
