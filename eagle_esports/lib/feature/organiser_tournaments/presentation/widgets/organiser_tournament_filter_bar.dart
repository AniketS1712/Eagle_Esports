import 'package:eagle_esports/core/theme/theme.dart';
import 'package:flutter/material.dart';

class OrganiserTournamentFilterBar extends StatelessWidget {
  const OrganiserTournamentFilterBar({
    required this.selectedStatus,
    required this.onSelected,
    super.key,
  });

  final String selectedStatus;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    const tabs = ['All', 'Live', 'Upcoming', 'Completed', 'Draft'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: AppSpacing.screenPadding,
      child: Row(
        children: tabs.map((label) {
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: FilterChipPill(
              label: label,
              selected: selectedStatus == label,
              onTap: () => onSelected(label),
            ),
          );
        }).toList(),
      ),
    );
  }
}
