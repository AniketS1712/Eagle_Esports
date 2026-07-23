import 'package:eagle_esports/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TeamRoomCredentialsCard extends StatelessWidget {
  const TeamRoomCredentialsCard({
    required this.isRevealed,
    this.roomId,
    this.roomPassword,
    super.key,
  });

  final bool isRevealed;
  final String? roomId;
  final String? roomPassword;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      withGlow: isRevealed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Room Credentials',
                  style: AppTextStyles.headlineMd,
                ),
              ),
              StatusBadge(status: isRevealed ? 'live' : 'pending'),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (!isRevealed)
            Text(
              'Room ID and password will appear here when the organiser starts the match.',
              style: AppTextStyles.bodySm,
            )
          else ...[
            _CredentialRow(label: 'Room ID', value: roomId ?? '—'),
            const SizedBox(height: AppSpacing.md),
            _CredentialRow(label: 'Password', value: roomPassword ?? '—'),
          ],
        ],
      ),
    );
  }
}

class _CredentialRow extends StatelessWidget {
  const _CredentialRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$label :", style: AppTextStyles.numberMd),
              const SizedBox(width: AppSpacing.md),
              Text(value, style: AppTextStyles.numberMd),
            ],
          ),
        ),
        IconActionButton(
          icon: Icons.copy,
          tooltip: 'Copy $label',
          onPressed: value == '—'
              ? null
              : () {
                  Clipboard.setData(ClipboardData(text: value));
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('$label copied')));
                },
        ),
      ],
    );
  }
}
