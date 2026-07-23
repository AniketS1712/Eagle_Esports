import 'package:eagle_esports/core/routes/route_names.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/wallet/presentation/providers/wallet_providers.dart';
import 'package:eagle_esports/feature/wallet/presentation/screens/transaction_details_screen.dart';
import 'package:eagle_esports/feature/wallet/presentation/widgets/transaction_list_item.dart';
import 'package:eagle_esports/feature/wallet/presentation/widgets/wallet_balance_card.dart';
import 'package:eagle_esports/shared/widgets/user_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const UserAppBar(),
              const SizedBox(height: AppSpacing.md),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Builder(
                  builder: (context) {
                    final walletAsync = ref.watch(walletStreamProvider);
                    return WalletBalanceCard(
                      wallet: walletAsync.value,
                      isLoading: walletAsync.isLoading,
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: PrimaryGradientButton(
                  text: 'ADD MONEY',
                  onPressed: () => context.pushNamed(RouteNames.addMoney),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Text(
                  'TRANSACTION HISTORY',
                  style: AppTextStyles.badgeLabel.copyWith(
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: ref
                    .watch(walletTransactionsProvider)
                    .when(
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
                              'Could not load transactions',
                              style: AppTextStyles.bodyMd,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            TextButton(
                              onPressed: () =>
                                  ref.invalidate(walletTransactionsProvider),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                      data: (transactions) => transactions.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.receipt_long_outlined,
                                    size: AppDimensions.iconXl,
                                    color: AppColors.outline,
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  const Text(
                                    'No transactions yet',
                                    style: AppTextStyles.bodyMd,
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  const Text(
                                    'Add money to get started',
                                    style: AppTextStyles.caption,
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(
                                AppSpacing.md,
                                0,
                                AppSpacing.md,
                                AppSpacing.xxxl,
                              ),
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: AppSpacing.sm),
                              itemCount: transactions.length,
                              itemBuilder: (_, i) => TransactionListItem(
                                transaction: transactions[i],
                                onTap: () => showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => TransactionDetailsScreen(
                                    transaction: transactions[i],
                                  ),
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
