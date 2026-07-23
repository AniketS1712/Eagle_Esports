import 'package:eagle_esports/core/theme/theme.dart';
import 'package:flutter/material.dart';

class CreateRoomForm extends StatefulWidget {
  const CreateRoomForm({
    required this.onSubmit,
    required this.entryFee,
    required this.isLoading,
    super.key,
  });

  final void Function(String teamName, String? inGameLeaderName) onSubmit;
  final double entryFee;
  final bool isLoading;

  @override
  State<CreateRoomForm> createState() => _CreateRoomFormState();
}

class _CreateRoomFormState extends State<CreateRoomForm> {
  final _formKey = GlobalKey<FormState>();
  final _teamNameController = TextEditingController();
  final _inGameLeaderNameController = TextEditingController();

  @override
  void dispose() {
    _teamNameController.dispose();
    _inGameLeaderNameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final inGameLeaderName = _inGameLeaderNameController.text.trim();
    widget.onSubmit(
      _teamNameController.text.trim(),
      inGameLeaderName.isEmpty ? null : inGameLeaderName,
    );
  }

  String get _entryFeeLabel {
    final fee = widget.entryFee;
    return fee == fee.roundToDouble()
        ? fee.toStringAsFixed(0)
        : fee.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: _teamNameController,
            hint: 'Team name',
            prefixIcon: const Icon(
              Icons.groups_outlined,
              color: AppColors.electricCyan,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter a team name';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _inGameLeaderNameController,
            hint: 'Your Free Fire IGN (optional)',
            prefixIcon: const Icon(
              Icons.sports_esports_outlined,
              color: AppColors.electricCyan,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Entry Fee: $_entryFeeLabel Talons',
                  style: AppTextStyles.labelMd,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'PAYMENT STUBBED',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.statusWarning,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryGradientButton(
            text: 'CREATE ROOM & PAY',
            isLoading: widget.isLoading,
            leadingIcon: const Icon(Icons.lock_open, color: Colors.white),
            onPressed: widget.isLoading ? null : _submit,
          ),
        ],
      ),
    );
  }
}
