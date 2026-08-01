import 'package:eagle_esports/models/tournament.dart';
import 'package:eagle_esports/core/routes/route_names.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/auth/presentation/providers/auth_providers.dart';
import 'package:eagle_esports/feature/team/presentation/providers/team_providers.dart';
import 'package:eagle_esports/feature/team/presentation/widgets/join_room_form.dart';
import 'package:eagle_esports/shared/widgets/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class JoinRoomScreen extends ConsumerStatefulWidget {
  const JoinRoomScreen({this.tournament, super.key});

  final Tournament? tournament;

  @override
  ConsumerState<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends ConsumerState<JoinRoomScreen> {
  Key _formKey = UniqueKey();

  Future<void> _submit(String inviteCode) async {
    try {
      final userId = ref.read(authNotifierProvider).value!.user.id;
      final notifier = ref.read(teamActionsProvider.notifier);

      await notifier.joinAndPayTeam(inviteCode: inviteCode, userId: userId);
      final teamId = notifier.lastJoinedTeamId;

      if (!mounted || teamId == null) return;
      context.goNamed(RouteNames.teamRoom, pathParameters: {'id': teamId});
    } catch (error) {
      if (!mounted) return;
      setState(() => _formKey = UniqueKey());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final actionsState = ref.watch(teamActionsProvider);

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTopBar(
                      title: 'Join Room',
                      backRouteName: widget.tournament != null
                          ? RouteNames.room
                          : RouteNames.home,
                      backRouteParams: widget.tournament != null
                          ? {'id': widget.tournament!.id}
                          : const {},
                      backRouteExtra: widget.tournament,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    Text(
                      'Enter the six-character invite code from your team leader.',
                      style: AppTextStyles.bodyMd,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    GlassCard(
                      withGlow: true,
                      padding: AppSpacing.cardPaddingLarge,
                      child: JoinRoomForm(
                        key: _formKey,
                        isLoading: actionsState.isLoading,
                        onSubmit: _submit,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
