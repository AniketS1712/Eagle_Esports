import 'package:eagle_esports/core/theme/app_colors.dart';
import 'package:eagle_esports/core/theme/app_spacing.dart';
import 'package:eagle_esports/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class EagleLogo extends StatelessWidget {
  final String subtitle;
  final bool showGlow;
  final double logoSize;
  final bool showLogo;

  const EagleLogo({
    super.key,
    required this.subtitle,
    this.showGlow = true,
    this.logoSize = 180,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            if (showGlow)
              Container(
                width: logoSize + 5,
                height: logoSize + 5,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.secondary.withValues(alpha: 0.8),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondary.withValues(alpha: 0.8),
                      blurRadius: 32,
                      spreadRadius: 8,
                    ),
                  ],
                ),
              ),
            if (showLogo)
              Hero(
                tag: 'app_logo',
                child: Image.asset(
                  'assets/images/logo.jpeg',
                  width: logoSize,
                  height: logoSize,
                  fit: BoxFit.contain,
                ),
              ),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),

        Text(
          'EAGLE ESPORTS',
          style: AppTextStyles.headlineLg.copyWith(
            color: AppColors.onBackground,
            shadows: [
              Shadow(
                color: AppColors.electricCyan.withValues(alpha: 0.8),
                blurRadius: 10,
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.xxs),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 1,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, AppColors.primary],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text(
                subtitle.toUpperCase(),
                style: AppTextStyles.labelMd.copyWith(
                  color: AppColors.outline,
                  fontSize: 11,
                  letterSpacing: 2,
                ),
              ),
            ),
            Container(
              width: 32,
              height: 1,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, Colors.transparent],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
