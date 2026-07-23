import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eagle_esports/feature/auth/presentation/providers/auth_providers.dart';
import 'package:eagle_esports/feature/merch/data/merch_repository.dart';
import 'package:eagle_esports/models/merch_item.dart';
import 'package:eagle_esports/models/merch_order.dart';

/// Provides a [MerchRepository] backed by the Supabase client.
final merchRepositoryProvider = Provider<MerchRepository>((ref) {
  return MerchRepository(ref.watch(supabaseClientProvider));
});

/// Tracks the currently selected category filter (null = All).
final selectedMerchCategoryProvider =
    NotifierProvider<SelectedMerchCategoryNotifier, String?>(
  SelectedMerchCategoryNotifier.new,
);

class SelectedMerchCategoryNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? category) => state = category;
  void clear() => state = null;
}

/// Fetches active merch items, optionally filtered by category.
final merchItemsProvider =
    FutureProvider.autoDispose.family<List<MerchItem>, String?>((
  ref,
  category,
) {
  return ref.watch(merchRepositoryProvider).fetchMerchItems(
    category: category,
  );
});

/// Fetches a single merch item by id.
final merchItemDetailProvider =
    FutureProvider.autoDispose.family<MerchItem, String>((ref, itemId) {
  return ref.watch(merchRepositoryProvider).fetchMerchItemById(itemId);
});

/// Fetches all orders for the authenticated user.
final myOrdersProvider =
    FutureProvider.autoDispose<List<MerchOrder>>((ref) async {
  final userId = ref.watch(authNotifierProvider).value?.user.id;
  if (userId == null) return [];
  return ref.watch(merchRepositoryProvider).fetchMyOrders(userId);
});

/// Streams a single order for live status updates.
final orderWatchProvider =
    StreamProvider.autoDispose.family<MerchOrder, String>((ref, orderId) {
  return ref.watch(merchRepositoryProvider).watchOrder(orderId);
});

/// Handles merch purchase actions (place order).
final merchActionsProvider =
    AsyncNotifierProvider<MerchActionsNotifier, void>(
  MerchActionsNotifier.new,
);

class MerchActionsNotifier extends AsyncNotifier<void> {
  String? _lastOrderId;

  /// The id of the most recently placed order.
  String? get lastOrderId => _lastOrderId;

  @override
  void build() {
    // Ready immediately — no initial async work.
  }

  /// Places an order. On success stores the order id for navigation.
  Future<void> placeOrder({
    required String userId,
    required String merchItemId,
    required int quantity,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(merchRepositoryProvider);
      final order = await repo.placeOrder(
        userId: userId,
        merchItemId: merchItemId,
        quantity: quantity,
      );
      _lastOrderId = order.id;
      ref.invalidate(myOrdersProvider);
    });
  }
}
