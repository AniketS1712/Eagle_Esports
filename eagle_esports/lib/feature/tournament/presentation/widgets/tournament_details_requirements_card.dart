import 'package:eagle_esports/core/theme/theme.dart';
import 'package:flutter/material.dart';

class TournamentDetailsRequirementsCard extends StatelessWidget {
  const TournamentDetailsRequirementsCard({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: wire eligibility data once tournament requirements providers exist.
    const rows = {
      'Min Level': '50+',
      'Platform': 'PC / Console',
      'Region': 'AS-South',
    };

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Requirement', style: AppTextStyles.headlineMd),
          const SizedBox(height: AppSpacing.md),
          ...rows.entries.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(child: Text(row.key, style: AppTextStyles.bodyMd)),
                  Text(
                    row.value,
                    style: AppTextStyles.headlineMd.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
