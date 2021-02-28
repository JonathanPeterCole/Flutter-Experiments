import 'package:flutter/material.dart';
import 'package:flutter_experiments/widgets/bars/fading_sliver_app_bar.dart';

class FadingSliverAppBarDemoScreen extends StatelessWidget {
  const FadingSliverAppBarDemoScreen({Key? key, this.pinned = false}) : super(key: key);

  final bool pinned;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        primary: true,
        slivers: [
          FadingSliverAppBar(
            pinned: pinned,
            title: const Text('FadingSliverAppBar Demo'),
            centerTitle: true,
          ),
          SliverSafeArea(
            top: false,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => const ListTile(title: Text('Example SliverList')),
                  childCount: 30),
            ),
          ),
        ],
      ),
    );
  }
}
