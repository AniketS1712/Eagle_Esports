import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';
import 'app_typography.dart';

/// Material 3 dark theme for the Eagle Esport command-center UI.
class AppTheme {
  const AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppTypography.fontManrope,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceContainerLowest: AppColors.surfaceContainerLowest,
        surfaceContainerLow: AppColors.surfaceContainerLow,
        surfaceContainer: AppColors.surfaceContainer,
        surfaceContainerHigh: AppColors.surfaceContainerHigh,
        surfaceContainerHighest: AppColors.surfaceContainerHighest,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        inverseSurface: AppColors.inverseSurface,
        onInverseSurface: AppColors.inverseOnSurface,
        inversePrimary: AppColors.inversePrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: AppTextStyles.headlineLgMobile,
        iconTheme: IconThemeData(
          color: AppColors.onSurface,
          size: AppDimensions.iconMd,
        ),
        centerTitle: false,
      ),
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.displayLg,
        headlineLarge: AppTextStyles.headlineLg,
        headlineMedium: AppTextStyles.headlineMd,
        headlineSmall: AppTextStyles.headlineLgMobile,
        titleLarge: AppTextStyles.numberLg,
        bodyLarge: AppTextStyles.bodyLg,
        bodyMedium: AppTextStyles.bodyMd,
        bodySmall: AppTextStyles.bodySm,
        labelLarge: AppTextStyles.labelMd,
        labelSmall: AppTextStyles.badgeLabel,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: AppRadius.radiusDefault),
          ),
          minimumSize: WidgetStateProperty.all(
            const Size(double.infinity, AppDimensions.buttonHeight),
          ),
          backgroundColor: WidgetStateProperty.all(AppColors.electricBlue),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          textStyle: WidgetStateProperty.all(
            AppTextStyles.labelMd.copyWith(letterSpacing: 1.5),
          ),
          elevation: WidgetStateProperty.all(0),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          side: WidgetStateProperty.all(
            const BorderSide(
              color: AppColors.electricCyan,
              width: AppDimensions.borderWidth,
            ),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: AppRadius.radiusDefault),
          ),
          minimumSize: WidgetStateProperty.all(
            const Size(double.infinity, AppDimensions.buttonHeight),
          ),
          foregroundColor: WidgetStateProperty.all(AppColors.electricCyan),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(AppColors.secondary),
          textStyle: WidgetStateProperty.all(AppTextStyles.linkText),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBackground,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.outlineVariant, width: 1),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.outlineVariant, width: 1),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.electricCyan,
            width: AppDimensions.focusBorderWidth,
          ),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.error),
        ),
        hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.outline),
        labelStyle: AppTextStyles.bodySm,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerLow.withValues(alpha: 0.7),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.radiusDefault,
          side: const BorderSide(color: AppColors.dividerColor, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceContainer,
        selectedItemColor: AppColors.electricCyan,
        unselectedItemColor: AppColors.outline,
        selectedLabelStyle: AppTextStyles.badgeLabel,
        unselectedLabelStyle: AppTextStyles.badgeLabel,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceContainerHigh,
        selectedColor: AppColors.electricCyan,
        disabledColor: AppColors.surfaceContainerHigh.withValues(alpha: 0.5),
        labelStyle: AppTextStyles.labelMd,
        secondaryLabelStyle: AppTextStyles.labelMd.copyWith(
          color: Colors.black,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusFull),
        side: BorderSide.none,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerColor,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceContainerHigh,
        contentTextStyle: AppTextStyles.bodyMd,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusDefault),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusLg),
        titleTextStyle: AppTextStyles.headlineMd,
        contentTextStyle: AppTextStyles.bodyMd,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.electricCyan,
        linearTrackColor: AppColors.surfaceContainerHigh,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.onSurface,
        size: AppDimensions.iconMd,
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: AppColors.electricCyan,
        unselectedLabelColor: AppColors.outline,
        labelStyle: AppTextStyles.labelMd,
        indicatorColor: AppColors.electricCyan,
      ),
    );
  }
}
