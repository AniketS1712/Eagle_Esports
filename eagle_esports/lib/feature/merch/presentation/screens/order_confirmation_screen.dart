import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eagle_esports/core/routes/route_names.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/merch/presentation/providers/merch_providers.dart';
import 'package:eagle_esports/models/merch_order.dart';

/// Screen displayed after placing a merch order, watching for realtime status.
class OrderConfirmationScreen extends ConsumerWidget {
  const OrderConfirmationScreen({required this.orderId, super.key});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderWatchProvider(orderId));

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.statusSuccess.withValues(alpha: 0.15),
                    ),
                    child: const Icon(
                      Icons.check_circle_outline,
                      size: AppDimensions.iconXl,
                      color: AppColors.statusSuccess,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Order Placed!', style: AppTextStyles.headlineLg),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Your Talons have been deducted. The admin will fulfill your order shortly.',
                    style: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  orderAsync.when(
                    loading: () => const CircularProgressIndicator(
                      color: AppColors.electricCyan,
                    ),
                    error: (e, st) => const SizedBox.shrink(),
                    data: (order) => GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Order Status', style: AppTextStyles.bodyMd),
                              StatusBadge(status: order.status.name),
                            ],
                          ),
                          if (order.status == MerchOrderStatus.fulfilled &&
                              order.fulfillmentNote != null) ...[
                            const SizedBox(height: AppSpacing.md),
                            const Divider(color: AppColors.dividerColor),
                            const SizedBox(height: AppSpacing.md),
                            Text('Your Code', style: AppTextStyles.headlineMd),
                            const SizedBox(height: AppSpacing.xs),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(
                                  ClipboardData(text: order.fulfillmentNote!),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Code copied!')),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                padding: AppSpacing.cardPadding,
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerHigh,
                                  borderRadius: AppRadius.radiusDefault,
                                  border: Border.all(
                                    color: AppColors.electricCyan,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        order.fulfillmentNote!,
                                        style: AppTextStyles.numberMd.copyWith(
                                          color: AppColors.electricCyan,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.copy_outlined,
                                      color: AppColors.electricCyan,
                                      size: AppDimensions.iconSm,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  PrimaryGradientButton(
                    text: 'VIEW MY ORDERS',
                    onPressed: () => context.goNamed(RouteNames.myOrders),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SecondaryOutlineButton(
                    text: 'BACK TO STORE',
                    onPressed: () => context.goNamed(RouteNames.merch),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
