import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_experiments/theme/custom_theme.dart';
import 'package:flutter_experiments/widgets/controls/buttons/platform_button.dart';

class OutlinedPlatformButton extends StatelessWidget {
  const OutlinedPlatformButton({
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
  Widget build(BuildContext context) => PlatformButton(
        onPressed: onPressed,
        label: label,
        loading: loading,
        leadingIcon: leadingIcon,
        trailingIcon: trailingIcon,
        focusColor: CustomTheme.of(context).primary.withOpacity(0.12),
        borderSide: BorderSide(width: 1, color: CustomTheme.of(context).primary),
      );
}
