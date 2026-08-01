import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:eagle_esports/core/routes/route_names.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/merch/presentation/providers/merch_providers.dart';
import 'package:eagle_esports/models/merch_order.dart';

/// Screen listing all merchandise redemption orders placed by the current user.
class MyOrdersScreen extends ConsumerWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(myOrdersProvider);

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: AppSpacing.screenPadding,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new),
                      onPressed: () => context.pop(),
                    ),
                    Text('My Orders', style: AppTextStyles.headlineLgMobile),
                  ],
                ),
              ),
              Expanded(
                child: ordersAsync.when(
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
                          'Could not load orders',
                          style: AppTextStyles.bodyMd,
                        ),
                        TextButton(
                          onPressed: () => ref.invalidate(myOrdersProvider),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                  data: (orders) => orders.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: AppDimensions.iconXl,
                                color: AppColors.outline,
                              ),
                              SizedBox(height: AppSpacing.md),
                              Text(
                                'No orders yet',
                                style: AppTextStyles.bodyMd,
                              ),
                              SizedBox(height: AppSpacing.xs),
                              Text(
                                'Redeem items from the merch store',
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.md,
                            AppSpacing.md,
                            AppSpacing.md,
                            AppSpacing.xxxl,
                          ),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: AppSpacing.md),
                          itemCount: orders.length,
                          itemBuilder: (_, i) => _OrderCard(order: orders[i]),
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

class _OrderCard extends ConsumerWidget {
  const _OrderCard({required this.order});

  final MerchOrder order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveOrder = ref
        .watch(orderWatchProvider(order.id))
        .maybeWhen(data: (data) => data, orElse: () => order);

    final idSubstring = order.id.length >= 8
        ? order.id.substring(0, 8).toUpperCase()
        : order.id.toUpperCase();

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text('Order #$idSubstring', style: AppTextStyles.bodyMd),
              ),
              StatusBadge(status: liveOrder.status.name),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${order.quantity}x item',
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                '${order.talonSpent.toStringAsFixed(0)} T spent',
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.statusSuccess,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            DateFormat('dd MMM yyyy • HH:mm').format(order.createdAt),
            style: AppTextStyles.caption,
          ),
          if (liveOrder.status == MerchOrderStatus.fulfilled &&
              liveOrder.fulfillmentNote != null) ...[
            const SizedBox(height: AppSpacing.sm),
            const Divider(color: AppColors.dividerColor),
            const SizedBox(height: AppSpacing.sm),
            GestureDetector(
              onTap: () {
                Clipboard.setData(
                  ClipboardData(text: liveOrder.fulfillmentNote!),
                );
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Code copied!')));
              },
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      liveOrder.fulfillmentNote!,
                      style: AppTextStyles.labelMd.copyWith(
                        color: AppColors.electricCyan,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.copy_outlined,
                    size: AppDimensions.iconSm,
                    color: AppColors.electricCyan,
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.pushNamed(
                RouteNames.orderConfirmation,
                pathParameters: {'orderId': order.id},
              ),
              child: const Text('View Details'),
            ),
          ),
        ],
      ),
    );
  }
}
