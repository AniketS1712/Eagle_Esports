import 'package:eagle_esports/core/theme/theme.dart';
import 'package:flutter/material.dart';

class TournamentFilterBar extends StatelessWidget {
  const TournamentFilterBar({
    required this.selectedStatusFilter,
    required this.selectedModeFilter,
    required this.onStatusSelected,
    required this.onModeSelected,
    super.key,
  });

  static const _statusFilters = ['Upcoming', 'Live'];

  static const _modeFilters = ['All', 'Solo', 'Duo', 'Squad'];

  final String selectedStatusFilter;
  final String selectedModeFilter;
  final ValueChanged<String> onStatusSelected;
  final ValueChanged<String> onModeSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FilterRow(
            filters: _statusFilters,
            selectedFilter: selectedStatusFilter,
            onSelected: onStatusSelected,
          ),
          const SizedBox(height: AppSpacing.sm),
          _FilterRow(
            filters: _modeFilters,
            selectedFilter: selectedModeFilter,
            onSelected: onModeSelected,
          ),
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.filters,
    required this.selectedFilter,
    required this.onSelected,
  });

  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: FilterChipPill(
              label: filter,
              selected: selectedFilter == filter,
              onTap: () => onSelected(filter),
            ),
          );
        }).toList(),
      ),
    );
  }
}
