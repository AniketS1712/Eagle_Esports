import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/models/profile.dart';
import 'package:eagle_esports/feature/profile/presentation/providers/profile_providers.dart';

class UserProfileStatsRow extends ConsumerWidget {
  final UserRole role;

  const UserProfileStatsRow({super.key, required this.role});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(userProfileStatsProvider);

    final String stat1Value;
    final String stat2Value;
    final String stat3Value;

    stat1Value = stats['tournamentsJoined'] ?? '—';
    stat2Value = '${stats['talonBalance'] ?? '0'}T';
    stat3Value = stats['totalWins'] ?? '—';

    return GlassCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatColumn(label: 'Joined', value: stat1Value),
          _StatColumn(label: 'Balance', value: stat2Value),
          _StatColumn(label: 'Total Wins', value: stat3Value),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;

  const _StatColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: AppTextStyles.numberMd.copyWith(color: AppColors.electricCyan),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
