import 'package:flutter/material.dart';
import 'package:eagle_esports/core/theme/theme.dart';

/// Horizontal scrollable category filter bar for the merch store.
class MerchCategoryBar extends StatelessWidget {
  const MerchCategoryBar({
    required this.selectedCategory,
    required this.onSelected,
    super.key,
  });

  final String? selectedCategory;
  final ValueChanged<String?> onSelected;

  static const _categories = <String?, String>{
    null: 'All',
    'gift_cards': 'Gift Cards',
    'apparel': 'Apparel',
    'accessories': 'Accessories',
    'gaming_gear': 'Gaming Gear',
    'collectibles': 'Collectibles',
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: _categories.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.xs),
            child: FilterChipPill(
              label: entry.value,
              selected: selectedCategory == entry.key,
              onTap: () => onSelected(entry.key),
            ),
          );
        }).toList(),
      ),
    );
  }
}
