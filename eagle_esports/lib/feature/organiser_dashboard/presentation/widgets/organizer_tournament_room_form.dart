import 'package:eagle_esports/core/theme/theme.dart';
import 'package:flutter/material.dart';

class OrganizerTournamentRoomForm extends StatelessWidget {
  const OrganizerTournamentRoomForm({
    required this.roomIdController,
    required this.passwordController,
    super.key,
  });

  final TextEditingController roomIdController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Room Setup', style: AppTextStyles.headlineMd),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Enter Free Fire room credentials before starting the match.',
            style: AppTextStyles.bodySm,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: roomIdController,
            label: 'Room ID',
            hint: 'Enter room ID',
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: passwordController,
            label: 'Room Password',
            hint: 'Enter password',
            obscureText: true,
          ),
        ],
      ),
    );
  }
}
