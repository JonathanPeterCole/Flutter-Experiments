import 'package:flutter/material.dart';
import 'package:flutter_experiments/widgets/common/bars/fading_sliver_app_bar.dart';

class FadingSliverAppBarDemoScreen extends StatelessWidget {

  const FadingSliverAppBarDemoScreen({Key? key, this.pinned = false}) : super(key: key);

  final bool pinned;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Builder(
      builder: (context) => CustomScrollView(
        primary: true,
        slivers: [
          FadingSliverAppBar(
            context,
            pinned: pinned,
            scrollController: PrimaryScrollController.of(context),
            title: const Text('FadingSliverAppBar Demo'),
            centerTitle: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => const ListTile(title: Text('Example SliverList')),
              childCount: 30
            ),
          ),
        ],
      ),
    ),
  );
}