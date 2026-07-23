import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:flutter/material.dart';

class TournamentDetailsRulesCard extends StatelessWidget {
  const TournamentDetailsRulesCard({required this.tournament, super.key});

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    final rules = tournament.rules?.trim();
    if (rules == null || rules.isEmpty) return const SizedBox.shrink();

    final ruleLines = rules
        .split(RegExp(r'\n+'))
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    return GlassCard(
      padding: AppSpacing.cardPaddingLarge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 4, height: 28, color: AppColors.electricCyan),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Rules & Regulations',
                  style: AppTextStyles.headlineMd.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...List.generate(ruleLines.length, (index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == ruleLines.length - 1 ? 0 : AppSpacing.md,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (index + 1).toString().padLeft(2, '0'),
                    style: AppTextStyles.labelMd.copyWith(
                      color: AppColors.electricCyan,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(ruleLines[index], style: AppTextStyles.bodyMd),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
