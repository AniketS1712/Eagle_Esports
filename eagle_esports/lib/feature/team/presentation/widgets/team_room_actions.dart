import 'package:eagle_esports/core/theme/theme.dart';
import 'package:flutter/material.dart';

class TeamRoomActions extends StatelessWidget {
  const TeamRoomActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryGradientButton(
          text: 'Finalize Roster',
          onPressed: () {},
          leadingIcon: const Icon(Icons.done_all, color: Colors.white),
        ),
        const SizedBox(height: AppSpacing.md),
        DangerButton(
          text: 'Leave Team',
          onPressed: () {},
          leadingIcon: const Icon(Icons.logout, color: Colors.white),
        ),
      ],
    );
  }
}
