import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Allows multiple initial pages in the navigator stack and provides more control over the stack.
///
/// Uses the new Navigator 2.0 pages API to manage the stack, allowing for more control over
/// navigation without complex class inheritance.
class CustomNavigator extends StatefulWidget {
  const CustomNavigator({Key? key, required this.initialPages}) : super(key: key);

  final List<Widget> initialPages;

  static CustomNavigatorState of(BuildContext context, {bool rootNavigator = false}) {
    if (rootNavigator) {
      return context.findRootAncestorStateOfType<CustomNavigatorState>()!;
    } else {
      return context.findAncestorStateOfType<CustomNavigatorState>()!;
    }
  }

  @override
  CustomNavigatorState createState() => CustomNavigatorState();
}

class CustomNavigatorState extends State<CustomNavigator> {
  late GlobalKey<NavigatorState> _navigatorKey;
  late HeroController _heroController;
  List<StackItem> pageStack = [];

  @override
  void initState() {
    super.initState();
    _navigatorKey = GlobalKey<NavigatorState>();
    _heroController = HeroController(
      createRectTween: (begin, end) => MaterialRectArcTween(begin: begin, end: end),
    );
    pageStack = widget.initialPages.map((page) => StackItem(page: page)).toList();
  }

  /// Push a new page to the stack.
  void push(Widget page, {OnCompleteCallback? onComplete}) {
    setState(() => pageStack.add(StackItem(page: page, onComplete: onComplete)));
  }

  /// Push multiple pages to the stack.
  void pushMultiple(List<Widget> pages) {
    setState(() => pageStack.addAll(pages.map((page) => StackItem(page: page))));
  }

  /// Replace the current page on the stack.
  void pushReplacement(Widget page, {OnCompleteCallback? onComplete}) {
    setState(() => pageStack.last = StackItem(page: page, onComplete: onComplete));
  }

  /// Pushes a new page and makes it the root.
  void pushRoot(Widget page) {
    setState(() => pageStack = [StackItem(page: page)]);
  }

  /// Pops the current page and calls onComplete with the result.
  void pop({dynamic? result, int count = 1}) {
    setState(() => pageStack.removeLast().onComplete?.call(result));
  }

  /// Pop until the shouldPop method returns [false].
  void popUntil(bool Function(Widget Widget) shouldPop) {
    bool endReached = false;
    while (!endReached) {
      pageStack.removeLast().onComplete?.call();
      endReached = !shouldPop(pageStack.last.page);
    }
    setState(() {});
  }

  /// Pop to the first page in the stack
  void popToRoot() {
    setState(() => pageStack = [pageStack.first]);
  }

  /// Handles the Android system back button action.
  Future<bool> onBackButtonPressed() async {
    return !await _navigatorKey.currentState!.maybePop();
  }

  /// Handles pages popped using iOS back swipe or the app bar back button.
  bool onPopPage(Route<dynamic> route, dynamic result) {
    if (!route.didPop(result)) {
      return false;
    }
    pageStack.removeLast();
    return true;
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: onBackButtonPressed,
        child: HeroControllerScope(
          controller: _heroController,
          child: Navigator(
            key: _navigatorKey,
            pages: pageStack.map((stackItem) => stackItem.toMaterialPage()).toList(),
            onPopPage: onPopPage,
          ),
        ),
      );
}

class StackItem {
  StackItem({required this.page, this.onComplete}) : key = UniqueKey();

  final LocalKey key;
  final Widget page;
  final OnCompleteCallback? onComplete;

  MaterialPage<dynamic> toMaterialPage() => MaterialPage<dynamic>(
        key: key,
        child: page,
      );
}

typedef OnCompleteCallback = void Function([dynamic? result]);
