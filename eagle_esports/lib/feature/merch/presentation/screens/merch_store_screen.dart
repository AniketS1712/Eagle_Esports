import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eagle_esports/core/routes/route_names.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/merch/presentation/providers/merch_providers.dart';
import 'package:eagle_esports/feature/merch/presentation/widgets/merch_category_bar.dart';
import 'package:eagle_esports/feature/merch/presentation/widgets/merch_item_card.dart';
import 'package:eagle_esports/feature/wallet/presentation/providers/wallet_providers.dart';

/// Root tab screen for browsing and purchasing merchandise items.
class MerchStoreScreen extends ConsumerWidget {
  const MerchStoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedMerchCategoryProvider);

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: AppSpacing.screenPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Merch Store', style: AppTextStyles.headlineLgMobile),
                    Consumer(
                      builder: (context, ref, _) {
                        final wallet = ref.watch(walletStreamProvider).value;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLowest,
                            borderRadius: AppRadius.radiusFull,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.account_balance_wallet,
                                color: AppColors.secondary,
                                size: AppDimensions.iconSm,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                '${wallet?.talonBalance.toStringAsFixed(0) ?? '0'} T',
                                style: AppTextStyles.labelMd.copyWith(
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              MerchCategoryBar(
                selectedCategory: selectedCategory,
                onSelected: (cat) => ref
                    .read(selectedMerchCategoryProvider.notifier)
                    .select(cat),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: ref.watch(merchItemsProvider(selectedCategory)).when(
                      loading: () => const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.electricCyan,
                        ),
                      ),
                      error: (e, _) => Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Could not load items',
                              style: AppTextStyles.bodyMd,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            TextButton(
                              onPressed: () => ref.invalidate(
                                merchItemsProvider(selectedCategory),
                              ),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                      data: (items) => items.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.shopping_bag_outlined,
                                    size: AppDimensions.iconXl,
                                    color: AppColors.outline,
                                  ),
                                  SizedBox(height: AppSpacing.md),
                                  Text(
                                    'No items available',
                                    style: AppTextStyles.bodyMd,
                                  ),
                                ],
                              ),
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                AppSpacing.md,
                                0,
                                AppSpacing.md,
                                AppSpacing.xxxl,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: AppSpacing.sm,
                                mainAxisSpacing: AppSpacing.sm,
                                childAspectRatio: 0.72,
                              ),
                              itemCount: items.length,
                              itemBuilder: (_, i) => MerchItemCard(
                                item: items[i],
                                onTap: () => context.pushNamed(
                                  RouteNames.merchItemDetail,
                                  pathParameters: {'id': items[i].id},
                                ),
                              ),
                            ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
