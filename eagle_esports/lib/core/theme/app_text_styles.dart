import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// Text tokens for the Eagle Esport command-center aesthetic.
///
/// Direct tokens mirror design.md. Supplementary tokens are derived for app
/// coverage by scaling from the nearest direct token. Orbitron has no w400, so
/// any future Orbitron regular token should use w500 as the documented fallback.
class AppTextStyles {
  const AppTextStyles._();

  /// Direct design.md token.
  static const TextStyle displayLg = TextStyle(
    fontFamily: AppTypography.fontOrbitron,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 56 / 48,
    letterSpacing: 48 * 0.05,
    color: AppColors.onSurface,
  );

  /// Direct design.md token.
  static const TextStyle headlineLg = TextStyle(
    fontFamily: AppTypography.fontOrbitron,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 40 / 32,
    letterSpacing: 32 * 0.02,
    color: AppColors.onSurface,
  );

  /// Direct design.md token.
  static const TextStyle headlineLgMobile = TextStyle(
    fontFamily: AppTypography.fontOrbitron,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
    color: AppColors.onSurface,
  );

  /// Direct design.md token.
  static const TextStyle headlineMd = TextStyle(
    fontFamily: AppTypography.fontOrbitron,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
    color: AppColors.onSurface,
  );

  /// Direct design.md token.
  static const TextStyle bodyLg = TextStyle(
    fontFamily: AppTypography.fontManrope,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 28 / 18,
    color: AppColors.onSurfaceVariant,
  );

  /// Direct design.md token.
  static const TextStyle bodyMd = TextStyle(
    fontFamily: AppTypography.fontManrope,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    color: AppColors.onSurfaceVariant,
  );

  /// Direct design.md token.
  static const TextStyle labelMd = TextStyle(
    fontFamily: AppTypography.fontOrbitron,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    color: AppColors.onSurface,
  );

  /// Direct design.md token.
  static const TextStyle numberXl = TextStyle(
    fontFamily: AppTypography.fontOrbitron,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1.0,
    color: AppColors.onSurface,
  );

  /// Derived supplementary token.
  static const TextStyle bodySm = TextStyle(
    fontFamily: AppTypography.fontManrope,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: AppColors.onSurfaceVariant,
  );

  /// Derived supplementary token.
  static const TextStyle caption = TextStyle(
    fontFamily: AppTypography.fontManrope,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    color: AppColors.outline,
  );

  /// Derived supplementary token.
  static const TextStyle numberLg = TextStyle(
    fontFamily: AppTypography.fontOrbitron,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.1,
    color: AppColors.onSurface,
  );

  /// Derived supplementary token.
  static const TextStyle numberMd = TextStyle(
    fontFamily: AppTypography.fontOrbitron,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.onSurface,
  );

  /// Derived supplementary token.
  static const TextStyle badgeLabel = TextStyle(
    fontFamily: AppTypography.fontOrbitron,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.0,
    letterSpacing: 1.0,
    color: AppColors.onSurface,
  );

  /// Derived supplementary token.
  static const TextStyle linkText = TextStyle(
    fontFamily: AppTypography.fontManrope,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.secondary,
    decoration: TextDecoration.underline,
  );
}
