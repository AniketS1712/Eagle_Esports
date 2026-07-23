import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/wallet/presentation/providers/wallet_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:eagle_esports/feature/auth/presentation/providers/auth_providers.dart';

class AddMoneyScreen extends ConsumerStatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  ConsumerState<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends ConsumerState<AddMoneyScreen> {
  late final Razorpay _razorpay;
  late WidgetRef _ref;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint('[Razorpay] SUCCESS paymentId=${response.paymentId}');
    _ref.read(walletActionsProvider.notifier).handlePaymentSuccess();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment successful! Talons added.')),
      );
      // Reset selected amount
      _ref.read(selectedTopupAmountProvider.notifier).clear();
      Navigator.of(context).pop();
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint(
      '[Razorpay] ERROR code=${response.code} message=${response.message}',
    );
    final message = response.message ?? 'Payment failed';
    _ref.read(walletActionsProvider.notifier).handlePaymentError(message);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Payment failed: $message')));
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('[Razorpay] EXTERNAL_WALLET name=${response.walletName}');
    // External wallets (Paytm etc.) are handled the same as error
    // for now — user can retry with card/UPI.
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('External wallet selected — please use UPI or card'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _ref = ref;
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
                    const Text(
                      'Add Money',
                      style: AppTextStyles.headlineLgMobile,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: SingleChildScrollView(
                  padding: AppSpacing.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SELECT AMOUNT',
                        style: AppTextStyles.badgeLabel.copyWith(
                          color: AppColors.onSurfaceVariant,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ref
                          .watch(topupOptionsProvider)
                          .when(
                            loading: () => const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.electricCyan,
                              ),
                            ),
                            error: (e, _) => const Text(
                              'Could not load options',
                              style: AppTextStyles.bodyMd,
                            ),
                            data: (options) => GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: AppSpacing.md,
                                    mainAxisSpacing: AppSpacing.md,
                                    childAspectRatio: 2.2,
                                  ),
                              itemCount: options.length,
                              itemBuilder: (context, index) {
                                final option = options[index];
                                final isSelected =
                                    ref.watch(selectedTopupAmountProvider) ==
                                    (option['amount'] as num).toDouble();
                                return _TopupOptionTile(
                                  option: option,
                                  isSelected: isSelected,
                                  onTap: () => ref
                                      .read(
                                        selectedTopupAmountProvider.notifier,
                                      )
                                      .select(
                                        (option['amount'] as num).toDouble(),
                                      ),
                                );
                              },
                            ),
                          ),
                      const SizedBox(height: AppSpacing.xl),
                      Builder(
                        builder: (context) {
                          final selected = ref.watch(
                            selectedTopupAmountProvider,
                          );
                          if (selected != null) {
                            return GlassCard(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'You will receive',
                                        style: AppTextStyles.bodyMd,
                                      ),
                                      Text(
                                        '${selected.toStringAsFixed(0)} Talons',
                                        style: AppTextStyles.numberMd.copyWith(
                                          color: AppColors.electricCyan,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Amount payable',
                                        style: AppTextStyles.bodyMd,
                                      ),
                                      Text(
                                        '₹${selected.toStringAsFixed(0)}',
                                        style: AppTextStyles.numberMd,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  const Text(
                                    '* 1 Talon = ₹1. Payment via Razorpay.',
                                    style: AppTextStyles.caption,
                                  ),
                                ],
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Builder(
                        builder: (context) {
                          final selected = ref.watch(
                            selectedTopupAmountProvider,
                          );
                          final isLoading = ref
                              .watch(walletActionsProvider)
                              .isLoading;
                          return PrimaryGradientButton(
                            text: selected != null
                                ? 'PAY ₹${selected.toStringAsFixed(0)}'
                                : 'SELECT AN AMOUNT',
                            enabled: selected != null && !isLoading,
                            isLoading: isLoading,
                            onPressed: selected == null || isLoading
                                ? null
                                : () async {
                                    debugPrint(
                                      '[AddMoney] Pay tapped amount=$selected',
                                    );
                                    final userId = ref
                                        .read(authNotifierProvider)
                                        .value
                                        ?.user
                                        .id;
                                    debugPrint('[AddMoney] userId=$userId');
                                    if (userId == null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Please sign in again'),
                                        ),
                                      );
                                      return;
                                    }
                                    try {
                                      await ref
                                          .read(walletActionsProvider.notifier)
                                          .initiateTopup(
                                            amount: selected,
                                            userId: userId,
                                            onCheckoutReady: (options) {
                                              // Open Razorpay checkout — must be called from widget context
                                              _razorpay.open(options);
                                            },
                                          );
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(content: Text('Error: $e')),
                                        );
                                      }
                                    }
                                  },
                          );
                        },
                      ),
                    ],
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

class _TopupOptionTile extends StatelessWidget {
  final Map<String, dynamic> option;
  final bool isSelected;
  final VoidCallback onTap;

  const _TopupOptionTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: AppRadius.radiusDefault,
          color: isSelected
              ? AppColors.electricBlue.withValues(alpha: 0.15)
              : AppColors.surfaceContainerHigh,
          border: Border.all(
            color: isSelected
                ? AppColors.electricBlue
                : AppColors.outlineVariant,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '₹${(option['amount'] as num).toStringAsFixed(0)}',
              style: AppTextStyles.numberMd.copyWith(
                color: isSelected
                    ? AppColors.electricCyan
                    : AppColors.onSurface,
              ),
            ),
            Text(
              '${(option['amount'] as num).toStringAsFixed(0)} Talons',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}
