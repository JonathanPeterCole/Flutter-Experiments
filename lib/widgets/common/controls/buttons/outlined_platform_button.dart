import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_experiments/theme/custom_theme.dart';
import 'package:flutter_experiments/widgets/common/controls/buttons/platform_button.dart';

class OutlinedPlatformButton extends StatelessWidget {

  OutlinedPlatformButton({
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
  Widget build(BuildContext context) => Theme.of(context).platform == TargetPlatform.iOS
    ? cupertinoButton(context) : materialButton(context);

  Widget cupertinoButton(BuildContext context) => PlatformButton(
    onPressed: onPressed,
    label: label,
    leadingIcon: leadingIcon,
    trailingIcon: trailingIcon,
    disabledForegroundColor: CustomTheme.of(context).primary.withOpacity(0.38),
    borderWidth: 1,
    borderColor: CustomTheme.of(context).primary,
    disabledBorderColor: CustomTheme.of(context).primary.withOpacity(0.38),
  );

  Widget materialButton(BuildContext context) => PlatformButton(
    onPressed: onPressed,
    label: label,
    leadingIcon: leadingIcon,
    trailingIcon: trailingIcon,
    borderWidth: 1,
    borderColor: CustomTheme.of(context).primary,
    disabledBorderColor: CustomTheme.of(context).primary.withOpacity(0.38),
    disabledForegroundColor: CustomTheme.of(context).primary.withOpacity(0.38),
  );
}