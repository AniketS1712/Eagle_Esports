import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/wallet/presentation/providers/wallet_providers.dart';
import 'package:eagle_esports/feature/wallet/presentation/widgets/topup_option_tile.dart';
import 'package:eagle_esports/feature/wallet/presentation/widgets/topup_summary_card.dart';
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

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final userId = ref.read(authNotifierProvider).value?.user.id;
    final selectedAmount = ref.read(selectedTopupAmountProvider);

    if (userId != null &&
        selectedAmount != null &&
        response.paymentId != null &&
        response.orderId != null &&
        response.signature != null) {
      try {
        await ref
            .read(walletActionsProvider.notifier)
            .confirmPayment(
              paymentId: response.paymentId!,
              orderId: response.orderId!,
              signature: response.signature!,
              userId: userId,
              amount: selectedAmount,
            );
      } catch (e) {
        _ref.read(walletActionsProvider.notifier).handlePaymentSuccess();
      }
    } else {
      _ref.read(walletActionsProvider.notifier).handlePaymentSuccess();
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment successful! Talons added.')),
      );
      // Reset selected amount
      _ref.read(selectedTopupAmountProvider.notifier).clear();
      context.pop();
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    final message = response.message ?? 'Payment failed';
    _ref.read(walletActionsProvider.notifier).handlePaymentError(message);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Payment failed: $message')));
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
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
                                return TopupOptionTile(
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
                            return TopupSummaryCard(selectedAmount: selected);
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
                                    final userId = ref
                                        .read(authNotifierProvider)
                                        .value
                                        ?.user
                                        .id;
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
                                      if (context.mounted) {
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
