import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/leaderboard/presentation/widgets/leaderboard_preview.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TournamentResultSheet extends ConsumerWidget {
  const TournamentResultSheet({required this.tournament, super.key});

  final Tournament tournament;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: const BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppRadius.xl),
            topRight: Radius.circular(AppRadius.xl),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    tournament.title,
                    style: AppTextStyles.headlineMd,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            const Divider(color: AppColors.dividerColor),
            const SizedBox(height: AppSpacing.sm),
            Expanded(child: LeaderboardPreview(tournamentId: tournament.id)),
          ],
        ),
      ),
    );
  }
}
