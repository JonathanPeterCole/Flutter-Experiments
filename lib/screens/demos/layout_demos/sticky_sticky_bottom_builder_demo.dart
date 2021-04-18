import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_experiments/theme/custom_theme.dart';
import 'package:flutter_experiments/widgets/bars/fading_sliver_app_bar.dart';
import 'package:flutter_experiments/widgets/scrolling/sliver_sticky_bottom_builder.dart';

class SliverStickyBottomBuilderDemoScreen extends StatelessWidget {
  Widget buildSliverChild(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      height: MediaQuery.of(context).size.height + 500,
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Text('😀'),
            Text('😁'),
            Text('😂'),
            Text('🤣'),
            Text('😃'),
            Text('😅'),
            Text('😆'),
            Text('😉'),
          ],
        ),
      ),
    );
  }

  Widget buildBottom(BuildContext context, double sizeOffset, double scrollOffset) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom * sizeOffset),
      child: DemoCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Sticky Bottom',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const Text('This won\'t move until scrolled to.')
                  ],
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedOpacity(
                    opacity: scrollOffset == 1 ? 1 : 0,
                    duration: const Duration(milliseconds: 150),
                    child: const Icon(Icons.check_circle),
                  ),
                  SizedBox(
                    height: 34,
                    width: 34,
                    child: CircularProgressIndicator(value: scrollOffset),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTrailingSliver(BuildContext context) {
    return SliverToBoxAdapter(
      child: DemoCard(
        padding: const EdgeInsets.all(8).copyWith(
          top: 0,
          bottom: 8 + MediaQuery.of(context).padding.bottom,
        ),
        child: Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: Text('Trailing sliver', style: Theme.of(context).textTheme.headline6),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        primary: true,
        clipBehavior: Clip.none,
        slivers: <Widget>[
          const FadingSliverAppBar(
            title: Text('SliverStickyBottom Demo'),
            centerTitle: true,
            pinned: true,
          ),
          SliverStickyBottomBuilder(
            child: buildSliverChild(context),
            bottomBuilder: buildBottom,
            bottomExtent: 82,
            stuckBottomExtent: 82 + MediaQuery.of(context).padding.bottom,
          ),
          buildTrailingSliver(context),
        ],
      ),
    );
  }
}

class DemoCard extends StatelessWidget {
  const DemoCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(8.0),
  }) : super(key: key);

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Material(
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        shadowColor: CustomTheme.of(context).shadow,
        child: child,
      ),
    );
  }
}
