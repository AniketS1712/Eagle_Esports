import 'package:eagle_esports/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CornerHud extends StatelessWidget {
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;

  const CornerHud({
    super.key,
    this.top = false,
    this.bottom = false,
    this.left = false,
    this.right = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border(
          top: top
              ? BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 2,
                )
              : BorderSide.none,
          bottom: bottom
              ? BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 2,
                )
              : BorderSide.none,
          left: left
              ? BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 2,
                )
              : BorderSide.none,
          right: right
              ? BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 2,
                )
              : BorderSide.none,
        ),
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
    );
  }
}
