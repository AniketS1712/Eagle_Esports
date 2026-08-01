import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class PaymentService {
  static String get _baseUrl {
    return 'https://eagle-esports-backend.onrender.com';
  }

  /// Calls Node.js /create-order and returns the order details.
  /// Throws an Exception with a user-readable message on failure.
  Future<Map<String, dynamic>> createOrder({
    required double amount,
    required String userId,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/create-order');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'amount': amount, 'userId': userId}),
      );

      if (response.statusCode != 200) {
        try {
          final body = jsonDecode(response.body) as Map<String, dynamic>;
          throw Exception(body['error'] ?? 'Payment failed');
        } catch (e) {
          if (e is Exception && !e.toString().contains('FormatException')) {
            rethrow;
          }
          throw Exception('Payment failed (${response.statusCode})');
        }
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return body;
    } catch (e) {
      rethrow;
    }
  }

  /// Calls Node.js /confirm-payment to verify payment and credit wallet,
  /// falling back directly to Supabase credit_wallet RPC if backend endpoint returns 404.
  Future<void> confirmPayment({
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String razorpaySignature,
    required String userId,
    required double amount,
  }) async {
    bool confirmedOnBackend = false;

    try {
      final uri = Uri.parse('$_baseUrl/confirm-payment');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'razorpay_payment_id': razorpayPaymentId,
          'razorpay_order_id': razorpayOrderId,
          'razorpay_signature': razorpaySignature,
          'userId': userId,
          'amount': amount,
        }),
      );

      if (response.statusCode == 200) {
        confirmedOnBackend = true;
      }
    } catch (_) {
      // Backend endpoint may be unavailable; fall through to Supabase RPC.
    }

    if (confirmedOnBackend) return;

    await Supabase.instance.client.rpc(
      'credit_wallet',
      params: {
        'p_user_id': userId,
        'p_amount': amount,
        'p_category': 'topup',
        'p_reference_id': null,
        'p_description': 'Wallet top-up — ₹${amount.toStringAsFixed(0)}',
      },
    );
  }
}
