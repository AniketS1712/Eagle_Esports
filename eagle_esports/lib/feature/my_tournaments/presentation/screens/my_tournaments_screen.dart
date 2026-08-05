import 'package:eagle_esports/core/routes/route_names.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/my_tournaments/presentation/providers/my_tournaments_providers.dart';
import 'package:eagle_esports/feature/my_tournaments/presentation/widgets/active_tournament_card.dart';
import 'package:eagle_esports/feature/my_tournaments/presentation/widgets/completed_tournament_card.dart';
import 'package:eagle_esports/feature/my_tournaments/presentation/widgets/tournament_result_sheet.dart';
import 'package:eagle_esports/shared/widgets/user_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MyTournamentsScreen extends ConsumerStatefulWidget {
  const MyTournamentsScreen({super.key});
  @override
  ConsumerState<MyTournamentsScreen> createState() => _ScreenState();
}

class _ScreenState extends ConsumerState<MyTournamentsScreen>
    with TickerProviderStateMixin {
  late final TabController _tab;
  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserAppBar(),
              const SizedBox(height: AppSpacing.sm),
              TabBar(
                controller: _tab,
                labelColor: AppColors.electricCyan,
                unselectedLabelColor: AppColors.outline,
                indicatorColor: AppColors.electricCyan,
                tabs: const [
                  Tab(text: 'ACTIVE'),
                  Tab(text: 'RESULTS'),
                ],
              ),
              const Divider(color: AppColors.dividerColor, height: 1),
              Expanded(
                child: TabBarView(
                  controller: _tab,
                  children: const [_ActiveTab(), _ResultsTab()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──── shared helpers ────

Widget _loader(int n) => Center(
  child: SizedBox(width: 120, child: SegmentedProgressBar(filled: n, total: 5)),
);

Widget _error(String msg, VoidCallback retry) => Center(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(msg, style: AppTextStyles.bodyMd),
      const SizedBox(height: AppSpacing.sm),
      TextButton(onPressed: retry, child: const Text('Retry')),
    ],
  ),
);

Widget _empty(IconData icon, String title, String sub) => Center(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: AppDimensions.iconXl, color: AppColors.outline),
      const SizedBox(height: AppSpacing.md),
      Text(title, style: AppTextStyles.bodyMd),
      const SizedBox(height: AppSpacing.xs),
      Text(sub, style: AppTextStyles.caption, textAlign: TextAlign.center),
    ],
  ),
);

const _pad = EdgeInsets.fromLTRB(
  AppSpacing.md,
  AppSpacing.md,
  AppSpacing.md,
  AppSpacing.xxxl,
);

// ──── tabs ────

class _ActiveTab extends ConsumerWidget {
  const _ActiveTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(activeTournamentsProvider)
        .when(
          loading: () => _loader(2),
          error: (_, _) => _error(
            "Couldn't load tournaments",
            () => ref.invalidate(activeTournamentsProvider),
          ),
          data: (items) {
            if (items.isEmpty) {
              return _empty(
                Icons.upcoming_outlined,
                'No active tournaments',
                'Tournaments you join will appear here',
              );
            }
            return ListView.separated(
              padding: _pad,
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.lg),
              itemBuilder: (_, i) => ActiveTournamentCard(
                tournament: items[i],
                onTap: () => context.pushNamed(
                  RouteNames.tournamentDetails,
                  pathParameters: {'id': items[i].id},
                ),
              ),
            );
          },
        );
  }
}

class _ResultsTab extends ConsumerWidget {
  const _ResultsTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(completedTournamentsProvider)
        .when(
          loading: () => _loader(4),
          error: (_, _) => _error(
            "Couldn't load results",
            () => ref.invalidate(completedTournamentsProvider),
          ),
          data: (items) {
            if (items.isEmpty) {
              return _empty(
                Icons.emoji_events_outlined,
                'No completed tournaments yet',
                'Results will appear here after tournaments complete',
              );
            }
            return ListView.separated(
              padding: _pad,
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.lg),
              itemBuilder: (ctx, i) => GestureDetector(
                onTap: () => showModalBottomSheet<void>(
                  context: ctx,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => TournamentResultSheet(tournament: items[i]),
                ),
                child: CompletedTournamentCard(tournament: items[i]),
              ),
            );
          },
        );
  }
}
