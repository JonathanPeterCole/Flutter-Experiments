import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_experiments/widgets/bars/fading_sliver_app_bar.dart';
import 'package:flutter_experiments/widgets/scrolling/sliver_sticky_bottom.dart';

class SliverStickyBottomDemoScreen extends StatelessWidget {
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
          SliverStickyBottom(
            child: Container(
              height: 2000,
              color: Colors.purple,
              child: const Placeholder(),
            ),
            bottom: Container(
              color: Colors.blueAccent,
              alignment: Alignment.center,
              child: const Align(
                alignment: Alignment.topCenter,
                child: Placeholder(
                  fallbackHeight: 100,
                ),
              ),
            ),
            bottomExtent: 100,
            stuckBottomExtent: 100 + MediaQuery.of(context).padding.bottom,
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
