import 'package:eagle_esports/core/theme/app_colors.dart';
import 'package:eagle_esports/core/theme/app_spacing.dart';
import 'package:eagle_esports/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class FormFieldSection extends StatelessWidget {
  final String label;
  final Widget child;

  const FormFieldSection({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelMd.copyWith(
            color: AppColors.primary,
            fontSize: 12,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        child,
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}
