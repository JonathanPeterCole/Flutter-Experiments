import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Displays buttons in a list with consistent padding and spacing across platforms.
class ButtonList extends StatelessWidget {
  const ButtonList({
    Key? key,
    this.padding,
    required this.buttons,
  }) : super(key: key);

  /// Button list padding.
  ///
  /// The default value will apply vertical padding on iOS, but no padding on Android, as the
  /// tap target padding creates the same effect.
  final EdgeInsets? padding;

  /// The buttons to display in a list.
  final List<Widget> buttons;

  /// Adds spacing between each button.
  Iterable<Widget> _addSpacing<Widget>(Widget spacing, Iterable<Widget> list) sync* {
    final iterator = list.iterator;
    if (iterator.moveNext()) {
      yield iterator.current;
      while (iterator.moveNext()) {
        yield spacing;
        yield iterator.current;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isCupertino = Theme.of(context).platform == TargetPlatform.iOS;
    return Padding(
      padding: padding ?? (isCupertino ? const EdgeInsets.symmetric(vertical: 6) : EdgeInsets.zero),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: isCupertino ? _addSpacing(const SizedBox(height: 8), buttons).toList() : buttons,
      ),
    );
  }
}
