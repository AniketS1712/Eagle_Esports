import 'package:eagle_esports/core/routes/route_names.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateTournamentButton extends StatelessWidget {
  const CreateTournamentButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryGradientButton(
      text: 'Create Tournament',
      leadingIcon: const Icon(Icons.add_circle_outline, color: Colors.black),
      onPressed: () => context.pushNamed(RouteNames.createTournament),
    );
  }
}
