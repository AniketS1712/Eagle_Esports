import 'package:flutter/material.dart';

/// Color tokens for Eagle Esport's futuristic HUD/glassmorphism theme.
///
/// Values are taken directly from design.md unless noted as helper aliases or
/// widget-specific utility methods.
class AppColors {
  const AppColors._();

  static const Color background = Color(0xFF0D112A);
  static const Color surface = Color(0xFF1A1E37);
  static const Color surfaceDim = Color(0xFF0D112A);
  static const Color surfaceBright = Color(0xFF343752);
  static const Color surfaceContainerLowest = Color(0xFF080C25);
  static const Color surfaceContainerLow = Color(0xFF161A33);
  static const Color surfaceContainer = Color(0xFF1A1E37);
  static const Color surfaceContainerHigh = Color(0xFF242842);
  static const Color surfaceContainerHighest = Color(0xFF2F334E);
  static const Color surfaceVariant = Color(0xFF2F334E);
  static const Color onBackground = Color(0xFFDEE0FF);
  static const Color onSurface = Color(0xFFDEE0FF);
  static const Color onSurfaceVariant = Color(0xFFC2C6D6);
  static const Color inverseSurface = Color(0xFFDEE0FF);
  static const Color inverseOnSurface = Color(0xFF2B2F49);
  static const Color outline = Color(0xFF8C909F);
  static const Color outlineVariant = Color(0xFF424754);

  static const Color primary = Color(0xFFADC6FF);
  static const Color onPrimary = Color(0xFF002E6A);
  static const Color primaryContainer = Color(0xFF4D8EFF);
  static const Color onPrimaryContainer = Color(0xFF00285D);
  static const Color inversePrimary = Color(0xFF005AC2);
  static const Color primaryFixed = Color(0xFFD8E2FF);
  static const Color primaryFixedDim = Color(0xFFADC6FF);
  static const Color onPrimaryFixed = Color(0xFF001A42);
  static const Color onPrimaryFixedVariant = Color(0xFF004395);

  static const Color secondary = Color(0xFFA2E7FF);
  static const Color onSecondary = Color(0xFF003642);
  static const Color secondaryContainer = Color(0xFF00D2FD);
  static const Color onSecondaryContainer = Color(0xFF005669);
  static const Color secondaryFixed = Color(0xFFB4EBFF);
  static const Color secondaryFixedDim = Color(0xFF3CD7FF);
  static const Color onSecondaryFixed = Color(0xFF001F27);
  static const Color onSecondaryFixedVariant = Color(0xFF004E5F);

  static const Color tertiary = Color(0xFFD0BCFF);
  static const Color onTertiary = Color(0xFF3C0091);
  static const Color tertiaryContainer = Color(0xFFA078FF);
  static const Color onTertiaryContainer = Color(0xFF340080);
  static const Color tertiaryFixed = Color(0xFFE9DDFF);
  static const Color tertiaryFixedDim = Color(0xFFD0BCFF);
  static const Color onTertiaryFixed = Color(0xFF23005C);
  static const Color onTertiaryFixedVariant = Color(0xFF5516BE);

  static const Color error = Color(0xFFFFB4AB);
  static const Color onError = Color(0xFF690005);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  static const Color electricBlue = Color(0xFF3B82F6);
  static const Color electricCyan = Color(0xFF00D4FF);
  static const Color glowBlue = Color(0xFF2563EB);
  static const Color inputBackground = Color(0xFF050714);
  static const Color dividerColor = Color(0xFF2A2F4A);

  static const Color statusLive = electricCyan;
  static const Color statusSuccess = Color(0xFF00E676);
  static const Color statusError = Color(0xFFFF3B30);
  static const Color statusWarning = Color(0xFFFFA726);
  static const Color statusPending = onSurfaceVariant;

  static const LinearGradient primaryButtonGradient = LinearGradient(
    colors: [secondary, electricBlue],
    begin: Alignment.topLeft,
    end: Alignment.topRight,
  );

  static const LinearGradient glassCardGradient = LinearGradient(
    colors: [AppColors.onPrimaryFixed, AppColors.surfaceContainerLowest],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const RadialGradient atmosphericOverlay = RadialGradient(
    colors: [AppColors.primary, Colors.transparent],
  );

  /// Maps tournament, payment, and async statuses to legible HUD colors.
  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'live':
        return statusLive;
      case 'upcoming':
        return primary;
      case 'completed':
        return onSurfaceVariant;
      case 'cancelled':
      case 'failed':
        return statusError;
      case 'paid':
      case 'success':
      case 'completed_payment':
        return statusSuccess;
      case 'pending':
        return statusWarning;
      default:
        return onSurfaceVariant;
    }
  }

  /// Reusable neon glow for elevated HUD elements.
  static List<BoxShadow> glowShadow(
    Color color, {
    double blur = 15,
    double opacity = 0.4,
  }) {
    return [
      BoxShadow(
        color: color.withValues(alpha: opacity),
        blurRadius: blur,
        spreadRadius: 0,
      ),
    ];
  }

  /// Drop-shadow style glow for icon-only actions.
  static List<BoxShadow> neonIconShadow(Color color) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.8),
        blurRadius: 6,
        spreadRadius: 2,
      ),
    ];
  }
}
