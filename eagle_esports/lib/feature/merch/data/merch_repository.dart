import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:eagle_esports/models/merch_item.dart';
import 'package:eagle_esports/models/merch_order.dart';

/// Data layer for the merch store — reads items, places orders,
/// and streams order status updates.
class MerchRepository {
  MerchRepository(this._client);
  final SupabaseClient _client;

  /// Fetches all active merch items ordered by created_at descending.
  /// Optionally filtered by [category] string (e.g. 'gift_cards').
  Future<List<MerchItem>> fetchMerchItems({String? category}) async {
    var query = _client.from('merch_items').select().eq('is_active', true);

    if (category != null) {
      query = query.eq('category', category);
    }

    final rows = await query.order('created_at', ascending: false);
    return rows.map((r) => MerchItem.fromMap(r)).toList();
  }

  /// Fetches a single merch item by [id].
  Future<MerchItem> fetchMerchItemById(String id) async {
    final data = await _client
        .from('merch_items')
        .select()
        .eq('id', id)
        .single();
    return MerchItem.fromMap(data);
  }

  /// Places a merch order. The DB trigger handles wallet debit and
  /// stock decrement — Flutter only sends user_id, merch_item_id,
  /// and quantity.
  Future<MerchOrder> placeOrder({
    required String userId,
    required String merchItemId,
    required int quantity,
  }) async {
    final data = await _client
        .from('merch_orders')
        .insert({
          'user_id': userId,
          'merch_item_id': merchItemId,
          'quantity': quantity,
        })
        .select()
        .single();
    return MerchOrder.fromMap(data);
  }

  /// Fetches all orders for [userId], most recent first.
  Future<List<MerchOrder>> fetchMyOrders(String userId) async {
    final rows = await _client
        .from('merch_orders')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return rows.map((r) => MerchOrder.fromMap(r)).toList();
  }

  /// Streams a single order for realtime fulfillment status updates.
  Stream<MerchOrder> watchOrder(String orderId) {
    return _client
        .from('merch_orders')
        .stream(primaryKey: ['id'])
        .eq('id', orderId)
        .map((rows) => MerchOrder.fromMap(rows.first));
  }
}
