import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:eagle_esports/feature/auth/presentation/providers/auth_providers.dart';
import 'package:eagle_esports/feature/wallet/data/wallet_repository.dart';
import 'package:eagle_esports/models/wallet.dart';
import 'package:eagle_esports/models/wallet_transaction.dart';
import 'package:eagle_esports/shared/services/payment_service.dart';

/// Provides a [WalletRepository] backed by the Supabase client.
final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return WalletRepository(ref.watch(supabaseClientProvider));
});

final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService();
});

/// Streams the authenticated user's wallet in realtime.
///
/// Returns `null` when unauthenticated or if no wallet row exists yet.
final walletStreamProvider = StreamProvider.autoDispose<Wallet?>((ref) {
  final userId = ref.watch(authNotifierProvider).value?.user.id;
  if (userId == null) return Stream.value(null);

  final repository = ref.watch(walletRepositoryProvider);
  return repository.watchWallet(userId).handleError((_) => null);
});

/// Fetches the authenticated user's transaction history (most recent first).
///
/// Returns an empty list when unauthenticated.
final walletTransactionsProvider =
    FutureProvider.autoDispose<List<WalletTransaction>>((ref) async {
      final userId = ref.watch(authNotifierProvider).value?.user.id;
      if (userId == null) return [];

      final repository = ref.watch(walletRepositoryProvider);
      return repository.fetchTransactions(userId);
    });

/// Fetches all active topup option tiers. No user-specific filtering.
final topupOptionsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
      return ref.watch(walletRepositoryProvider).fetchTopupOptions();
    });

/// Holds the currently selected topup amount on the Add Money screen.
///
/// `null` means nothing is selected yet.
final selectedTopupAmountProvider =
    NotifierProvider<SelectedTopupAmountNotifier, double?>(
      SelectedTopupAmountNotifier.new,
    );

class SelectedTopupAmountNotifier extends Notifier<double?> {
  @override
  double? build() => null;

  void select(double? amount) => state = amount;
  void clear() => state = null;
}

/// Handles wallet actions such as initiating a topup.
///
/// Actual payment integration (Razorpay via Node.js) is stubbed until
/// the backend is ready.
final walletActionsProvider =
    AsyncNotifierProvider<WalletActionsNotifier, void>(
      WalletActionsNotifier.new,
    );

class WalletActionsNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // No-op — notifier is ready immediately.
  }

  /// Initiates a topup of [amount] Talons.
  ///
  /// Once the Node.js backend exists this will:
  ///  1. POST to `/create-order` with `{amount, userId}`
  ///  2. Receive `{orderId, keyId}`
  ///  3. Open Razorpay checkout
  ///  4. On payment success, Node.js webhook credits the wallet
  ///  5. [walletStreamProvider] updates in realtime
  Future<void> initiateTopup({
    required double amount,
    required String userId,
    required void Function(Map<String, dynamic> options) onCheckoutReady,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(paymentServiceProvider);
      final order = await service.createOrder(amount: amount, userId: userId);

      // Build Razorpay options map and pass back to the screen
      // via callback — Razorpay.open() must be called from a widget
      // context, not from a provider.
      final options = <String, dynamic>{
        'key': order['keyId'],
        'order_id': order['orderId'],
        'amount': (amount * 100).toInt(),
        'currency': 'INR',
        'name': 'Eagle Esport',
        'description': 'Wallet Top-up',
        'prefill': {'contact': '', 'email': ''},
      };

      onCheckoutReady(options);
      debugPrint('[Payment] onCheckoutReady called with options=$options');
      // Do NOT set state = AsyncData here — the notifier stays in
      // loading state until the screen calls handlePaymentSuccess
      // or handlePaymentError below.
    });
  }

  /// Called by the screen on Razorpay.EVENT_PAYMENT_SUCCESS.
  void handlePaymentSuccess() {
    state = const AsyncData(null);

    // The webhook takes a moment to process the payment and credit the database.
    // We delay the invalidation slightly to ensure we fetch the updated data.
    Future.delayed(const Duration(seconds: 2), () {
      ref.invalidate(walletStreamProvider);
      ref.invalidate(walletTransactionsProvider);
    });
  }

  /// Called by the screen on Razorpay.EVENT_PAYMENT_ERROR.
  void handlePaymentError(String message) {
    state = AsyncError(Exception(message), StackTrace.current);
  }
}
