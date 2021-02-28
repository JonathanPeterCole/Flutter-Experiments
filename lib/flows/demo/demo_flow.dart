import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_experiments/flows/common/flow_controller_mixin.dart';
import 'package:flutter_experiments/widgets/navigation/custom_navigator.dart';

import '../../screens/demos/flow_demos/flow_demo_screen.dart';

class DemoFlow with FlowControllerMixin {
  void start(BuildContext context) {
    present(context, FlowDemoScreen(onFinish: onFinishDemoScreen));
  }

  void onFinishDemoScreen(BuildContext context, bool endFlow) {
    if (endFlow) {
      CustomNavigator.of(context).popToRoot();
    } else {
      CustomNavigator.of(context).push(FlowDemoScreen(onFinish: onFinishDemoScreen));
    }
  }
}
