import 'package:eagle_esports/core/routes/route_names.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/auth/presentation/providers/auth_providers.dart';
import 'package:eagle_esports/feature/team/presentation/providers/team_providers.dart';
import 'package:eagle_esports/feature/team/presentation/widgets/create_room_form.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:eagle_esports/shared/widgets/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateRoomScreen extends ConsumerStatefulWidget {
  const CreateRoomScreen({required this.tournament, super.key});

  final Tournament tournament;

  @override
  ConsumerState<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends ConsumerState<CreateRoomScreen> {
  Future<void> _submit(String teamName, String? inGameLeaderName) async {
    try {
      final userId = ref.read(authNotifierProvider).value!.user.id;
      final teamId = await ref
          .read(teamActionsProvider.notifier)
          .createAndPayTeam(
            tournamentId: widget.tournament.id,
            teamName: teamName,
            leaderId: userId,
            inGameLeaderName: inGameLeaderName,
          );

      if (!mounted) return;
      context.goNamed(RouteNames.teamRoom, pathParameters: {'id': teamId});
    } catch (error) {
      if (!mounted) return;
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
                      title: 'Create Room',
                      backRouteName: RouteNames.room,
                      backRouteParams: {'id': widget.tournament.id},
                      backRouteExtra: widget.tournament,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    Text(widget.tournament.title, style: AppTextStyles.labelMd),
                    const SizedBox(height: AppSpacing.lg),
                    CreateRoomForm(
                      entryFee: widget.tournament.entryFee,
                      isLoading: actionsState.isLoading,
                      onSubmit: _submit,
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
