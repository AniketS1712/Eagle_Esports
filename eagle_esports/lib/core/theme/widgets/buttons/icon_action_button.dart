import 'package:flutter/material.dart';

import '../../app_colors.dart';
import '../../app_dimensions.dart';
import '../../app_radius.dart';

/// Circular icon-only action with a subtle neon icon shadow.
class IconActionButton extends StatelessWidget {
  const IconActionButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.onSecondary,
        borderRadius: AppRadius.radiusFull,
        boxShadow: AppColors.neonIconShadow(AppColors.electricCyan),
      ),
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: AppDimensions.iconXl,
          height: AppDimensions.iconXl,
          child: Icon(
            icon,
            size: AppDimensions.iconMd,
            color: AppColors.secondary,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );

    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}
