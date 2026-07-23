import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';

/// Reusable decorations implementing the design.md elevation and depth spec.
class AppDecorations {
  const AppDecorations._();

  static BoxDecoration glassCard({
    BorderRadius? radius,
    bool withGlow = false,
    Color glowColor = AppColors.electricBlue,
  }) {
    return BoxDecoration(
      gradient: AppColors.glassCardGradient,
      borderRadius: radius ?? AppRadius.radiusDefault,
      // True linear-gradient borders require a custom painter. This solid
      // translucent border is the production-friendly fallback.
      border: Border.all(
        color: AppColors.electricBlue.withValues(alpha: 0.3),
        width: 1,
      ),
      boxShadow: withGlow
          ? AppColors.glowShadow(glowColor, blur: 4, opacity: 0.3)
          : null,
    );
  }

  static BoxDecoration baseLayerBackground() {
    return const BoxDecoration(color: AppColors.surfaceContainerLowest);
  }

  static BoxDecoration neonInputFocused() {
    return BoxDecoration(
      color: AppColors.inputBackground,
      border: const Border(
        bottom: BorderSide(color: AppColors.electricCyan, width: 1.5),
      ),
      boxShadow: AppColors.glowShadow(
        AppColors.electricCyan,
        blur: 6,
        opacity: 0.5,
      ),
    );
  }

  static BoxDecoration igniteDivider() {
    return BoxDecoration(
      color: AppColors.electricCyan,
      boxShadow: AppColors.glowShadow(
        AppColors.electricCyan,
        blur: 4,
        opacity: 0.4,
      ),
    );
  }
}
