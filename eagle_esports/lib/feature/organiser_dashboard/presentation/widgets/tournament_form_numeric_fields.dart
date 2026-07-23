import 'package:eagle_esports/core/theme/theme.dart';
import 'package:flutter/material.dart';

class TournamentFormNumericFields extends StatelessWidget {
  const TournamentFormNumericFields({
    required this.maxSlotsController,
    required this.entryFeeController,
    super.key,
  });

  final TextEditingController maxSlotsController;
  final TextEditingController entryFeeController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          controller: maxSlotsController,
          hint: 'Max slots',
          keyboardType: TextInputType.number,
          prefixIcon: const Icon(Icons.groups_outlined),
          validator: _positiveNumber,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: entryFeeController,
          hint: 'Entry fee',
          keyboardType: TextInputType.number,
          prefixIcon: const Icon(Icons.payments_outlined),
          validator: _positiveNumber,
        ),
        // Prize pool field removed — now derived automatically from
        // TournamentFormPrizeFields (sum of rank-wise prize amounts).
      ],
    );
  }

  String? _positiveNumber(String? value) {
    final number = num.tryParse(value?.trim() ?? '');
    if (number == null) return 'Required';
    if (number <= 0) return 'Must be greater than 0';
    return null;
  }
}
