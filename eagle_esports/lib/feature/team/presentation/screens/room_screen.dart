import 'package:eagle_esports/core/routes/route_names.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:eagle_esports/shared/widgets/app_top_bar.dart';

class RoomScreen extends StatelessWidget {
  const RoomScreen({required this.tournament, super.key});

  final Tournament? tournament;

  void _goToCreateRoom(BuildContext context) {
    final selectedTournament = tournament;
    if (selectedTournament == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Tournament data missing')));
      return;
    }

    context.goNamed(
      RouteNames.createRoom,
      pathParameters: {'id': selectedTournament.id},
      extra: selectedTournament,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 96, 24, 32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'ROOM SETUP',
                          style: AppTextStyles.headlineLgMobile.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Create a squad lobby or join an existing team before registration closes.',
                          style: AppTextStyles.bodyMd,
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        _RoomActionCard(
                          icon: Icons.add_circle_outline,
                          title: 'Create Room',
                          description:
                              'Start a new team room and invite players with a room code.',
                          child: PrimaryGradientButton(
                            text: 'Create Room',
                            leadingIcon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            onPressed: () => _goToCreateRoom(context),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _RoomActionCard(
                          icon: Icons.login,
                          title: 'Join Room',
                          description:
                              'Enter the room code shared by your team leader.',
                          child: SecondaryOutlineButton(
                            text: 'Join Room',
                            leadingIcon: const Icon(Icons.arrow_forward),
                            onPressed: () =>
                                context.goNamed(RouteNames.joinRoom, extra: tournament),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AppTopBar(
                title: 'EAGLE ESPORTS',
                backRouteName: RouteNames.tournamentDetails,
                backRouteParams: {'id': tournament?.id ?? ''},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoomActionCard extends StatelessWidget {
  const _RoomActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.child,
  });

  final IconData icon;
  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      withGlow: true,
      padding: AppSpacing.cardPaddingLarge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.electricCyan),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.headlineMd,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(description, style: AppTextStyles.bodySm),
          const SizedBox(height: AppSpacing.lg),
          child,
        ],
      ),
    );
  }
}

