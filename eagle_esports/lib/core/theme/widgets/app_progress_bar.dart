import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_dimensions.dart';
import '../app_radius.dart';

/// Segmented HUD progress bar for slot and lobby capacity indicators.
class SegmentedProgressBar extends StatelessWidget {
  const SegmentedProgressBar({
    required this.filled,
    required this.total,
    this.height = AppDimensions.progressBarHeight,
    super.key,
  });

  final int filled;
  final int total;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (total <= 0) {
      return const SizedBox.shrink();
    }

    // Rendering is capped at 20 cells to keep large tournaments readable. Above
    // that threshold, cells represent a smooth proportional distribution.
    const maxCells = 20;
    final visibleCells = total > maxCells ? maxCells : total;
    final filledCells = ((filled.clamp(0, total) / total) * visibleCells)
        .ceil()
        .clamp(0, visibleCells);

    return SizedBox(
      height: height,
      child: Row(
        children: List.generate(visibleCells, (index) {
          final isFilled = index < filledCells;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(
                right: index == visibleCells - 1
                    ? 0
                    : AppDimensions.progressCellGap,
              ),
              decoration: BoxDecoration(
                color: isFilled
                    ? AppColors.electricCyan
                    : AppColors.surfaceContainerHigh,
                borderRadius: AppRadius.radiusSm,
                boxShadow: isFilled
                    ? AppColors.glowShadow(
                        AppColors.electricCyan,
                        blur: 4,
                        opacity: 0.35,
                      )
                    : null,
              ),
            ),
          );
        }),
      ),
    );
  }
}
