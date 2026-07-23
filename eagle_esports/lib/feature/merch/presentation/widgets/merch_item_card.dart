import 'package:flutter/material.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/models/merch_item.dart';

/// Card displaying a merch item summary in the store grid.
class MerchItemCard extends StatelessWidget {
  const MerchItemCard({
    required this.item,
    required this.onTap,
    super.key,
  });

  final MerchItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppRadius.defaultRadius),
                topRight: Radius.circular(AppRadius.defaultRadius),
              ),
              child: item.images.isNotEmpty
                  ? Image.network(
                      item.images.first,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 140,
                        color: AppColors.surfaceContainerHigh,
                        child: const Icon(
                          Icons.image_outlined,
                          color: AppColors.outline,
                          size: AppDimensions.iconLg,
                        ),
                      ),
                    )
                  : Container(
                      height: 140,
                      color: AppColors.surfaceContainerHigh,
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        color: AppColors.outline,
                        size: AppDimensions.iconLg,
                      ),
                    ),
            ),
            Padding(
              padding: AppSpacing.cardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: AppTextStyles.headlineMd,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${item.price.toStringAsFixed(0)} T',
                        style: AppTextStyles.numberMd.copyWith(
                          color: AppColors.electricCyan,
                        ),
                      ),
                      if (item.stockQuantity <= 0)
                        const StatusBadge(status: 'out_of_stock')
                      else if (item.stockQuantity <= 5)
                        Text(
                          'Only ${item.stockQuantity} left',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.statusWarning,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
