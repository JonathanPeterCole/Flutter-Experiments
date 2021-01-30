import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_experiments/widgets/common/bars/platform_app_bar.dart';
import 'package:flutter_experiments/widgets/common/controls/buttons/contained_button.dart';
import 'package:flutter_experiments/widgets/common/controls/buttons/text_platform_button.dart';

class FlowDemoScreen extends StatelessWidget {
  const FlowDemoScreen({Key? key, required this.onFinish}) : super(key: key);

  final Function(BuildContext context, bool endFlow) onFinish;

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PlatformAppBar(
          context,
          title: const Text('Flow Demo'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'This is an example flow.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'It doesn\'t care where it came from or where it\'s going next. It just lets '
                'the flow know that it\'s finished, and the rest is handled by the flow itself.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              ContainedPlatformButton(
                label: const Text('Next Page'),
                onPressed: () => onFinish(context, false),
              ),
              TextPlatformButton(
                label: const Text('Exit Flow'),
                onPressed: () => onFinish(context, true),
              ),
            ],
          ),
        ),
      );
}
