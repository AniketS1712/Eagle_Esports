import 'package:flutter/material.dart';
import 'package:eagle_esports/core/theme/theme.dart';

class TopupOptionTile extends StatelessWidget {
  final Map<String, dynamic> option;
  final bool isSelected;
  final VoidCallback onTap;

  const TopupOptionTile({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: AppRadius.radiusDefault,
          color: isSelected
              ? AppColors.electricBlue.withValues(alpha: 0.15)
              : AppColors.surfaceContainerHigh,
          border: Border.all(
            color: isSelected
                ? AppColors.electricBlue
                : AppColors.outlineVariant,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '₹${(option['amount'] as num).toStringAsFixed(0)}',
              style: AppTextStyles.numberMd.copyWith(
                color: isSelected
                    ? AppColors.electricCyan
                    : AppColors.onSurface,
              ),
            ),
            Text(
              '${(option['amount'] as num).toStringAsFixed(0)} Talons',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}
