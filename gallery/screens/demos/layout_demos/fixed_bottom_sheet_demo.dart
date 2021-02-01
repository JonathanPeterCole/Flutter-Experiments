import 'package:flutter/material.dart';
import 'package:flutter_experiments/widgets/common/bars/platform_app_bar.dart';
import 'package:flutter_experiments/widgets/common/controls/buttons/contained_button.dart';
import 'package:flutter_experiments/widgets/common/controls/buttons/text_platform_button.dart';
import 'package:flutter_experiments/widgets/common/layouts/fixed_bottom_sheet_layout.dart';

class FixedBottomSheetDemoScreen extends StatelessWidget {
  const FixedBottomSheetDemoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: PlatformAppBar(
          context,
          centerTitle: true,
          title: const Text('Fixed Bottom Sheet Demo'),
        ),
        body: FixedBottomSheetLayout(
            leading: const Text('By creating an account, you agree to our Terms and Conditions.'),
            buttons: [
              ContainedPlatformButton(onPressed: () {}, label: const Text('Primary Action')),
              TextPlatformButton(onPressed: () {}, label: const Text('Secondary')),
            ],
            body: ListView.builder(
              itemBuilder: (context, index) => ListTile(title: Text('Tile ' + index.toString())),
              itemCount: 30,
            )),
      );
}
