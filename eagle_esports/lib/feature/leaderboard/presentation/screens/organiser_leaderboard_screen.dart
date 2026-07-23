import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/leaderboard/presentation/providers/leaderboard_providers.dart';
import 'package:eagle_esports/feature/leaderboard/presentation/widgets/leaderboard_preview.dart';
import 'package:eagle_esports/feature/leaderboard/presentation/widgets/match_result_form.dart';
import 'package:eagle_esports/feature/leaderboard/presentation/widgets/match_tab_bar.dart';
import 'package:eagle_esports/feature/tournament/presentation/providers/tournament_providers.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Organiser-side leaderboard screen: create matches, enter scores,
/// view the overall leaderboard, and complete the tournament.
class OrganiserLeaderboardScreen extends ConsumerStatefulWidget {
  const OrganiserLeaderboardScreen({
    required this.tournamentId,
    super.key,
  });

  final String tournamentId;

  @override
  ConsumerState<OrganiserLeaderboardScreen> createState() =>
      _OrganiserLeaderboardScreenState();
}

class _OrganiserLeaderboardScreenState
    extends ConsumerState<OrganiserLeaderboardScreen> {
  Future<void> _addMatch(int nextNumber) async {
    try {
      await ref
          .read(leaderboardActionsProvider.notifier)
          .createMatch(widget.tournamentId, nextNumber);
    } catch (e) {
      if (mounted) _snack('Error: $e');
    }
  }

  Future<void> _completeTournament() async {
    try {
      await ref
          .read(tournamentActionsProvider.notifier)
          .complete(widget.tournamentId);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) _snack('Error: $e');
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final matchesAsync =
        ref.watch(tournamentMatchesProvider(widget.tournamentId));
    final teamsAsync =
        ref.watch(paidTeamsProvider(widget.tournamentId));
    final tournamentAsync =
        ref.watch(tournamentDetailProvider(widget.tournamentId));
    final isAdding = ref.watch(leaderboardActionsProvider).isLoading;
    final isCompleting =
        ref.watch(tournamentActionsProvider).isLoading;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          bottom: false,
          child: matchesAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                Center(child: Text('Error: $e')),
            data: (matches) => teamsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Center(child: Text('Error: $e')),
              data: (teams) => _Body(
                tournamentId: widget.tournamentId,
                matches: matches,
                teams: teams,
                isAdding: isAdding,
                isCompleting: isCompleting,
                onAddMatch: () => _addMatch(matches.length + 1),
                onComplete: _completeTournament,
                isLive: tournamentAsync.value?.status ==
                    TournamentStatus.live,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.tournamentId,
    required this.matches,
    required this.teams,
    required this.isAdding,
    required this.isCompleting,
    required this.onAddMatch,
    required this.onComplete,
    required this.isLive,
  });

  final String tournamentId;
  final List<Map<String, dynamic>> matches;
  final List<Map<String, dynamic>> teams;
  final bool isAdding;
  final bool isCompleting;
  final VoidCallback onAddMatch;
  final VoidCallback onComplete;
  final bool isLive;

  @override
  Widget build(BuildContext context) {
    final tabHelper = MatchTabBar(
      matchCount: matches.length,
      onAddMatch: onAddMatch,
      isAddingMatch: isAdding,
    );
    final tabCount = matches.length + 1; // +1 for Overall

    return DefaultTabController(
      length: tabCount,
      child: Column(
        children: [
          // Header
          Padding(
            padding: AppSpacing.screenPadding,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: AppColors.onSurface),
                  onPressed: () => context.pop(),
                ),
                Text('Leaderboard',
                    style: AppTextStyles.headlineLgMobile),
                const Spacer(),
                IconButton(
                  onPressed: isAdding ? null : onAddMatch,
                  icon: isAdding
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2),
                        )
                      : const Icon(Icons.add,
                          color: AppColors.electricCyan),
                ),
              ],
            ),
          ),
          // Tabs
          TabBar(
            isScrollable: true,
            labelColor: AppColors.electricCyan,
            unselectedLabelColor: AppColors.outline,
            indicatorColor: AppColors.electricCyan,
            tabs: tabHelper.tabs,
          ),
          // Tab views
          Expanded(
            child: TabBarView(
              children: [
                for (final m in matches)
                  MatchResultForm(
                    matchId: m['id'] as String,
                    teams: teams,
                  ),
                LeaderboardPreview(tournamentId: tournamentId),
              ],
            ),
          ),
          // Complete button
          if (isLive)
            Padding(
              padding: AppSpacing.screenPadding.copyWith(
                bottom: AppSpacing.xl,
              ),
              child: PrimaryGradientButton(
                text: 'Complete Tournament',
                onPressed: onComplete,
                isLoading: isCompleting,
              ),
            ),
        ],
      ),
    );
  }
}
