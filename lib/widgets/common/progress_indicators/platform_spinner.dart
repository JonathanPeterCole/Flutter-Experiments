import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_experiments/theme/custom_theme.dart';
import 'package:flutter_experiments/widgets/common/progress_indicators/custom_cupertino_activity_indicator.dart';

/// An indeterminate progress indicator that adapts to the current platform.
///
/// On Android, the spinner will have a diameter of 36 and use the primary color by default.
/// On iOS, the spinner will have a diameter of 20 and the color will be based on the theme
/// brightness by default.
class PlatformSpinner extends StatelessWidget {
  const PlatformSpinner({Key? key, this.diameter, this.weight, this.color}) : super(key: key);

  /// The size of the spinner.
  final double? diameter;

  /// The thickness of the spinner (applies to Android only).
  final double? weight;

  /// The spinner color.
  final Color? color;

  Widget _buildMaterialSpinner(BuildContext context) => CircularProgressIndicator(
        strokeWidth: weight ?? 4.0,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? CustomTheme.of(context).primary),
      );

  Widget _buildCupertinoSpinner() => CustomCupertinoActivityIndicator(
        color: color,
      );

  @override
  Widget build(BuildContext context) {
    final bool isCupertino = Theme.of(context).platform == TargetPlatform.iOS;
    final double effectiveSize = diameter ?? (isCupertino ? 20 : 36);
    return SizedBox(
      height: effectiveSize,
      width: effectiveSize,
      child: isCupertino ? _buildCupertinoSpinner() : _buildMaterialSpinner(context),
    );
  }
}
