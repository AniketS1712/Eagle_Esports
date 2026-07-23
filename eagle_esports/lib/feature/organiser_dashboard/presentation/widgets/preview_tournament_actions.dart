import 'package:eagle_esports/core/theme/theme.dart';
import 'package:flutter/material.dart';

class PreviewTournamentActions extends StatelessWidget {
  const PreviewTournamentActions({
    required this.onEdit,
    required this.onPublish,
    this.isLoading = false,
    super.key,
  });

  final VoidCallback onEdit;
  final VoidCallback onPublish;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrimaryGradientButton(
          text: 'Publish Tournament',
          isLoading: isLoading,
          onPressed: onPublish,
        ),
        const SizedBox(height: AppSpacing.sm),
        SecondaryOutlineButton(
          text: 'Edit Details',
          onPressed: onEdit,
        ),
      ],
    );
  }
}
