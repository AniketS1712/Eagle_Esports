import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/tournament/presentation/providers/tournament_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateTournamentSubmitButton extends ConsumerWidget {
  const CreateTournamentSubmitButton({required this.onSubmit, super.key});

  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actionState = ref.watch(tournamentActionsProvider);

    ref.listen(tournamentActionsProvider, (previous, next) {
      if (!next.hasError) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(next.error.toString())));
    });

    return PrimaryGradientButton(
      text: 'Create',
      isLoading: actionState.isLoading,
      onPressed: onSubmit,
    );
  }
}
