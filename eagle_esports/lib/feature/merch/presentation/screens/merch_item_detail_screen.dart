import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eagle_esports/core/routes/route_names.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/auth/presentation/providers/auth_providers.dart';
import 'package:eagle_esports/feature/merch/presentation/providers/merch_providers.dart';
import 'package:eagle_esports/feature/merch/presentation/widgets/merch_image_carousel.dart';
import 'package:eagle_esports/models/merch_item.dart';

/// Screen displaying detailed information and purchasing options for a merch item.
class MerchItemDetailScreen extends ConsumerStatefulWidget {
  const MerchItemDetailScreen({
    required this.itemId,
    super.key,
  });

  final String itemId;

  @override
  ConsumerState<MerchItemDetailScreen> createState() =>
      _MerchItemDetailScreenState();
}

class _MerchItemDetailScreenState
    extends ConsumerState<MerchItemDetailScreen> {
  int _quantity = 1;

  String _categoryLabel(MerchCategory cat) {
    switch (cat) {
      case MerchCategory.giftCards:
        return 'Gift Cards';
      case MerchCategory.apparel:
        return 'Apparel';
      case MerchCategory.accessories:
        return 'Accessories';
      case MerchCategory.gamingGear:
        return 'Gaming Gear';
      case MerchCategory.collectibles:
        return 'Collectibles';
    }
  }

  Future<void> _redeem(
      BuildContext context, WidgetRef ref, MerchItem item) async {
    final userId = ref.read(authNotifierProvider).value?.user.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in again')),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerHigh,
        title: Text('Confirm Redemption', style: AppTextStyles.headlineMd),
        content: Text(
          'Redeem ${_quantity}x ${item.name} for ${(item.price * _quantity).toStringAsFixed(0)} Talons?\nThis cannot be undone.',
          style: AppTextStyles.bodyMd,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel',
                style: TextStyle(color: AppColors.onSurfaceVariant)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirm',
                style: TextStyle(color: AppColors.electricCyan)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!context.mounted) return;

    try {
      await ref.read(merchActionsProvider.notifier).placeOrder(
            userId: userId,
            merchItemId: item.id,
            quantity: _quantity,
          );
      final orderId = ref.read(merchActionsProvider.notifier).lastOrderId;
      if (context.mounted && orderId != null) {
        context.pushNamed(
          RouteNames.orderConfirmation,
          pathParameters: {'orderId': orderId},
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemAsync = ref.watch(merchItemDetailProvider(widget.itemId));

    return Scaffold(
      body: AppBackground(
        child: itemAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.electricCyan),
          ),
          error: (e, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Could not load item details',
                    style: AppTextStyles.bodyMd),
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: () => ref
                      .invalidate(merchItemDetailProvider(widget.itemId)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (item) => CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: MerchImageCarousel(images: item.images),
              ),
              SliverPadding(
                padding: AppSpacing.screenPadding,
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new),
                          onPressed: () => context.pop(),
                        ),
                        const Spacer(),
                      ],
                    ),
                    Text(item.name, style: AppTextStyles.headlineLg),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${item.price.toStringAsFixed(0)} T',
                          style: AppTextStyles.numberXl
                              .copyWith(color: AppColors.electricCyan),
                        ),
                        Text(
                          '${item.stockQuantity} in stock',
                          style: AppTextStyles.bodySm.copyWith(
                            color: item.stockQuantity > 0
                                ? AppColors.statusSuccess
                                : AppColors.statusError,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          borderRadius: AppRadius.radiusFull,
                        ),
                        child: Text(_categoryLabel(item.category),
                            style: AppTextStyles.badgeLabel),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (item.description != null &&
                        item.description!.isNotEmpty) ...[
                      Text('About this item', style: AppTextStyles.headlineMd),
                      const SizedBox(height: AppSpacing.xs),
                      Text(item.description!, style: AppTextStyles.bodyMd),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                    GlassCard(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Quantity', style: AppTextStyles.bodyMd),
                          Row(
                            children: [
                              IconActionButton(
                                icon: Icons.remove,
                                onPressed: _quantity > 1
                                    ? () => setState(() => _quantity--)
                                    : null,
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Text('$_quantity',
                                  style: AppTextStyles.numberMd),
                              const SizedBox(width: AppSpacing.md),
                              IconActionButton(
                                icon: Icons.add,
                                onPressed: _quantity < item.stockQuantity
                                    ? () => setState(() => _quantity++)
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    GlassCard(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total cost', style: AppTextStyles.bodyMd),
                          Text(
                            '${(item.price * _quantity).toStringAsFixed(0)} T',
                            style: AppTextStyles.numberMd
                                .copyWith(color: AppColors.electricCyan),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Consumer(
                      builder: (context, ref, _) {
                        final isLoading =
                            ref.watch(merchActionsProvider).isLoading;
                        return PrimaryGradientButton(
                          text: item.stockQuantity <= 0
                              ? 'OUT OF STOCK'
                              : 'REDEEM FOR ${(item.price * _quantity).toStringAsFixed(0)} T',
                          enabled: item.stockQuantity > 0 && !isLoading,
                          isLoading: isLoading,
                          onPressed: item.stockQuantity <= 0
                              ? null
                              : () => _redeem(context, ref, item),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
