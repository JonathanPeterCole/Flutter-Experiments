import 'package:flutter/material.dart';
import 'package:flutter_experiments/theme/custom_theme.dart';
import 'package:flutter_experiments/widgets/common/layouts/button_list.dart';

/// Displays a fixed bottom sheet below a page body.
class FixedBottomSheetLayout extends StatelessWidget {
  const FixedBottomSheetLayout({
    Key? key,
    required this.body,
    this.leading,
    this.buttons,
  }) : super(key: key);

  /// The layout body (usually a ScrollView).
  final Widget body;

  /// The widget to display before the buttons in the bottom sheet.
  final Widget? leading;

  /// The buttons to display in the bottom sheet.
  final List<Widget>? buttons;

  Widget _buildLeading(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: DefaultTextStyle(
          style: TextStyle(
            height: 1.2,
            color: CustomTheme.of(context).textPrimary,
          ),
          textAlign: TextAlign.center,
          child: leading!,
        ),
      );

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: body),
          Material(
            elevation: 8,
            color: CustomTheme.of(context).surface,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (leading != null) _buildLeading(context),
                    if (leading != null && buttons != null) const SizedBox(height: 4),
                    if (buttons != null) ButtonList(buttons: buttons!),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
}
