import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_dimensions.dart';
import '../app_radius.dart';
import '../app_spacing.dart';
import '../app_text_styles.dart';

/// Selectable pill chip for tournament filters and mode filters.
class FilterChipPill extends StatelessWidget {
  const FilterChipPill({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.radiusFull,
        child: Ink(
          height: AppDimensions.chipHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            gradient: selected ? AppColors.primaryButtonGradient : null,
            color: selected ? null : AppColors.surfaceContainerHigh,
            borderRadius: AppRadius.radiusFull,
          ),
          child: Center(
            child: Text(
              label.toUpperCase(),
              style: AppTextStyles.labelMd.copyWith(
                color: selected ? Colors.black : AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
