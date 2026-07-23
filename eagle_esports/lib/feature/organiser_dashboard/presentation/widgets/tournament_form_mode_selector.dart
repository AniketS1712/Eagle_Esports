import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:flutter/material.dart';

class TournamentFormModeSelector extends StatelessWidget {
  const TournamentFormModeSelector({
    required this.selectedMode,
    required this.onChanged,
    super.key,
  });

  final GameMode selectedMode;
  final ValueChanged<GameMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Game Mode', style: AppTextStyles.labelMd),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: GameMode.values.map((mode) {
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: FilterChipPill(
                label: mode.name,
                selected: selectedMode == mode,
                onTap: () => onChanged(mode),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
