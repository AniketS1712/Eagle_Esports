import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  // NOTE: This is the localhost address for development.
  // Must be changed to the production Railway/Render URL before release.
  static String get _baseUrl {
    return 'https://sassy-drizzly-trapdoor.ngrok-free.dev/';
  }

  /// Calls Node.js /create-order and returns the order details.
  /// Throws an Exception with a user-readable message on failure.
  Future<Map<String, dynamic>> createOrder({
    required double amount,
    required String userId,
  }) async {
    debugPrint('[Payment] calling /create-order amount=$amount userId=$userId');
    try {
      final uri = Uri.parse('$_baseUrl/create-order');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'amount': amount, 'userId': userId}),
      );
      debugPrint(
        '[Payment] status=${response.statusCode} body=${response.body}',
      );
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        throw Exception(body['error'] ?? 'Payment failed');
      }
      return body;
    } catch (e, st) {
      debugPrint('[Payment] ERROR: $e');
      debugPrint('[Payment] STACK: $st');
      rethrow;
    }
  }
}
