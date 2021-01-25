import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_experiments/theme/custom_theme.dart';
import 'package:flutter_experiments/widgets/common/controls/buttons/platform_button.dart';

class TextPlatformButton extends StatelessWidget {

  TextPlatformButton({
    Key? key,
    required this.onPressed,
    required this.label,
    this.leadingIcon,
    this.trailingIcon,
  });

  final VoidCallback? onPressed;
  final Widget label;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  @override
  Widget build(BuildContext context) => PlatformButton(
    onPressed: onPressed,
    label: label,
    leadingIcon: leadingIcon,
    trailingIcon: trailingIcon,
    focusColor: CustomTheme.of(context).primary.withOpacity(0.12),
  );
}