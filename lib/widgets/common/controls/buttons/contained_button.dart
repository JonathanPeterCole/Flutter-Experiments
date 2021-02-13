import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_experiments/theme/custom_theme.dart';
import 'package:flutter_experiments/widgets/common/controls/buttons/platform_button.dart';

class ContainedPlatformButton extends StatelessWidget {
  const ContainedPlatformButton({
    Key? key,
    required this.onPressed,
    required this.label,
    this.loading,
    this.leadingIcon,
    this.trailingIcon,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget label;
  final bool? loading;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  @override
  Widget build(BuildContext context) => Theme.of(context).platform == TargetPlatform.iOS
      ? cupertinoButton(context)
      : materialButton(context);

  Widget cupertinoButton(BuildContext context) => PlatformButton(
        onPressed: onPressed,
        label: label,
        loading: loading,
        leadingIcon: leadingIcon,
        trailingIcon: trailingIcon,
        color: CustomTheme.of(context).primary,
        foregroundColor: CustomTheme.of(context).onPrimary,
        focusColor: CustomTheme.of(context).onPrimary.withOpacity(0.12),
      );

  Widget materialButton(BuildContext context) => PlatformButton(
        onPressed: onPressed,
        label: label,
        loading: loading,
        leadingIcon: leadingIcon,
        trailingIcon: trailingIcon,
        color: CustomTheme.of(context).primary,
        foregroundColor: CustomTheme.of(context).onPrimary,
        focusColor: CustomTheme.of(context).onPrimary.withOpacity(0.12),
        elevation: 2.0,
        focusElevation: 4.0,
        highlightElevation: 8.0,
        disabledElevation: 0,
      );
}
