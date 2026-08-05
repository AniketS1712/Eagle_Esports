import 'package:eagle_esports/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppTopBar extends StatelessWidget {
  const AppTopBar({
    required this.title,
    required this.backRouteName,
    this.titleColor = AppColors.primary,
    this.trailingWidget,
    this.backRouteParams = const {},
    this.backRouteExtra,
    super.key,
  });

  final String title;
  final String backRouteName;
  final Color titleColor;
  final Widget? trailingWidget;
  final Map<String, String> backRouteParams;
  final Object? backRouteExtra;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.72),
          border: Border(
            bottom: BorderSide(
              color: AppColors.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          boxShadow: AppColors.glowShadow(
            AppColors.primary,
            blur: 15,
            opacity: 0.18,
          ),
        ),
        child: SizedBox(
          height: AppDimensions.appBarHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Row(
              children: [
                IconActionButton(
                  icon: Icons.arrow_back,
                  onPressed: () {
                    context.pop();
                  },
                  tooltip: 'Back',
                ),
                const SizedBox(width: AppSpacing.xxl),
                Expanded(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.headlineMd.copyWith(
                      color: titleColor,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                ?trailingWidget,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
