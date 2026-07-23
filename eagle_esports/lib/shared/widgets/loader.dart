import 'package:eagle_esports/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SegmentedLoader extends StatelessWidget {
  final int activeSegment;

  const SegmentedLoader({super.key, required this.activeSegment});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(8, (index) {
        final isActive = index == activeSegment;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Transform(
            transform: Matrix4.skewX(-0.3),
            child: Container(
              width: 6,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(
                  alpha: isActive ? 1 : 0.2,
                ),
                boxShadow: isActive
                    ? AppColors.glowShadow(
                        AppColors.secondary,
                        blur: 8,
                        opacity: 0.8,
                      )
                    : null,
              ),
            ),
          ),
        );
      }),
    );
  }
}
