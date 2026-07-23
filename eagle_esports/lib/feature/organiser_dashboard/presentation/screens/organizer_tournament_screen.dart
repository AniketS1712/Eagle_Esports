import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/organiser_dashboard/presentation/widgets/organizer_tournament_actions.dart';
import 'package:eagle_esports/feature/organiser_dashboard/presentation/widgets/organizer_tournament_header.dart';
import 'package:eagle_esports/feature/organiser_dashboard/presentation/widgets/organizer_tournament_room_form.dart';
import 'package:eagle_esports/feature/organiser_dashboard/presentation/widgets/organizer_tournament_stats.dart';
import 'package:eagle_esports/shared/widgets/app_top_bar.dart';
import 'package:eagle_esports/core/routes/route_names.dart';
import 'package:go_router/go_router.dart';
import 'package:eagle_esports/feature/tournament/presentation/providers/tournament_providers.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:eagle_esports/shared/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrganizerTournamentScreen extends ConsumerStatefulWidget {
  const OrganizerTournamentScreen({required this.tournamentId, super.key});

  final String tournamentId;

  @override
  ConsumerState<OrganizerTournamentScreen> createState() =>
      _OrganizerTournamentScreenState();
}

class _OrganizerTournamentScreenState
    extends ConsumerState<OrganizerTournamentScreen> {
  final _roomIdController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _roomIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _startTournament() async {
    final roomId = _roomIdController.text.trim();
    final password = _passwordController.text.trim();
    if (roomId.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter room ID and password')),
      );
      return;
    }

    await ref
        .read(tournamentActionsProvider.notifier)
        .start(
          tournamentId: widget.tournamentId,
          roomId: roomId,
          roomPassword: password,
        );
  }

  Future<void> _cancelTournament() async {
    await ref
        .read(tournamentActionsProvider.notifier)
        .cancel(widget.tournamentId);
  }

  Future<void> _completeTournament() async {
    await ref
        .read(tournamentActionsProvider.notifier)
        .complete(widget.tournamentId);
  }

  Future<void> _manageLeaderboard() async {
    context.pushNames(
      RouteNames.organiserLeaderboard,
      pathParameters: {'id': widget.tournamentId},
    );
  }

  @override
  Widget build(BuildContext context) {
    final tournamentAsync = ref.watch(
      tournamentDetailProvider(widget.tournamentId),
    );
    final actionsState = ref.watch(tournamentActionsProvider);
    final isLoading = actionsState.isLoading;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          bottom: false,
          child: tournamentAsync.when(
            loading: () =>
                const Center(child: SegmentedLoader(activeSegment: 2)),
            error: (error, stackTrace) => Center(
              child: Text(
                "Couldn't load tournament",
                style: AppTextStyles.bodyMd,
              ),
            ),
            data: (tournament) => _OrganizerTournamentBody(
              tournament: tournament,
              roomIdController: _roomIdController,
              passwordController: _passwordController,
              isLoading: isLoading,
              onStart: _startTournament,
              onCancel: _cancelTournament,
              onComplete: _completeTournament,
              onLeaderboard: _manageLeaderboard,
            ),
          ),
        ),
      ),
    );
  }
}

class _OrganizerTournamentBody extends StatelessWidget {
  const _OrganizerTournamentBody({
    required this.tournament,
    required this.roomIdController,
    required this.passwordController,
    required this.isLoading,
    required this.onStart,
    required this.onCancel,
    required this.onComplete,
    required this.onLeaderboard,
  });

  final Tournament tournament;
  final TextEditingController roomIdController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onStart;
  final VoidCallback onCancel;
  final VoidCallback onComplete;
  final VoidCallback onLeaderboard;

  bool get _showRoomForm => tournament.status == TournamentStatus.upcoming;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: AppDimensions.appBarHeight,
            bottom: AppSpacing.xxxl,
          ),
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OrganizerTournamentHeader(tournament: tournament),
                const SizedBox(height: AppSpacing.lg),
                OrganizerTournamentStats(tournament: tournament),
                if (_showRoomForm) ...[
                  const SizedBox(height: AppSpacing.lg),
                  OrganizerTournamentRoomForm(
                    roomIdController: roomIdController,
                    passwordController: passwordController,
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                SecondaryOutlineButton(
                  text: 'REGISTERED TEAMS',
                  onPressed: () => context.pushNamed(
                    RouteNames.registeredTeams,
                    pathParameters: {'tournamentId': tournament.id},
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                OrganizerTournamentActions(
                  tournament: tournament,
                  onStart: onStart,
                  onCancel: onCancel,
                  onComplete: onComplete,
                  onLeaderboard: onLeaderboard,
                  isLoading: isLoading,
                ),
                const SizedBox(height: AppSpacing.xxxl),
              ],
            ),
          ),
        ),
        const AppTopBar(
          title: 'EAGLE ESPORTS',
          titleColor: AppColors.secondary,
          trailingWidget: CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.surfaceContainerHigh,
            child: Icon(Icons.person, color: AppColors.secondary),
          ),
          backRouteName: RouteNames.organiserDashboard,
        ),
      ],
    );
  }
}
