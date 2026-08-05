import 'package:flutter/material.dart';

import '../../app_colors.dart';
import '../../app_radius.dart';
import '../../app_spacing.dart';
import '../../app_text_styles.dart';

/// Cyan pro-tier badge, optionally accented for higher categories.
class ProBadge extends StatelessWidget {
  const ProBadge({this.accented = false, super.key});

  final bool accented;

  @override
  Widget build(BuildContext context) {
    return _BadgeShell(
      backgroundColor: AppColors.electricCyan,
      textColor: Colors.black,
      text: 'PRO',
      border: accented ? Border.all(color: AppColors.tertiary) : null,
      boxShadow: AppColors.glowShadow(
        AppColors.electricCyan,
        blur: 8,
        opacity: 0.35,
      ),
    );
  }
}

class _BadgeShell extends StatelessWidget {
  const _BadgeShell({
    required this.backgroundColor,
    required this.textColor,
    required this.text,
    this.border,
    this.boxShadow,
  });

  final Color backgroundColor;
  final Color textColor;
  final String text;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.radiusFull,
        border: border,
        boxShadow: boxShadow,
      ),
      child: Text(
        text,
        style: AppTextStyles.badgeLabel.copyWith(color: textColor),
      ),
    );
  }
}
