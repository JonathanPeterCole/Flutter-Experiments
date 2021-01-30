import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// A basic controller designed to allow for flow classes that control the navigation between
/// reusable screens, without the screens themselves holding navigation logic for each of the
/// different circumstances where they are displayed.
///
/// I originally attempted using a separate navigator for each flow, but this presented some
/// challenges, including controlling which navigator should handle system back button/gestures,
/// automatically showing the back button in the AppBar on the root page of each nested navigator,
/// and displaying hero transitions between routes in different navigators.
///
/// Known issues:
/// - Popping a flow will animate out every route that has been pushed since the flow started,
///   which has a major performance hit. Ideally routes between the current route and the route
///   we're popping to should be removed from the stack without animating.
mixin FlowControllerMixin {
  /// The route before the flow.
  Route<dynamic>? _previousRoute;

  /// The first route of the flow.
  Route<dynamic>? _firstRoute;

  /// Pushes the first page of the flow to the navigation stack.
  @protected
  void present(BuildContext context, Widget initialScreen) {
    _previousRoute = ModalRoute.of(context);
    _firstRoute = MaterialPageRoute<dynamic>(
      builder: (context) => initialScreen,
    );
    Navigator.push<dynamic>(context, _firstRoute!);
  }

  /// Pops to the page before the flow.
  void popFlow(BuildContext context) =>
      Navigator.popUntil(context, (route) => route == _previousRoute);

  /// Pops to the first page in the flow.
  void popToFlowRoot(BuildContext context) =>
      Navigator.popUntil(context, (route) => route == _firstRoute);

  /// Replaces the flow with a new route.
  @optionalTypeArgs
  Future<T?> replaceFlow<T extends Object?, TO extends Object?>(
          BuildContext context, Route<T> newRoute,
          {TO? result}) =>
      Navigator.pushAndRemoveUntil(context, newRoute, (route) => route == _previousRoute);
}
