import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eagle_esports/core/routes/route_names.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/wallet/presentation/providers/wallet_providers.dart';

class CreateRoomForm extends ConsumerStatefulWidget {
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
  ConsumerState<CreateRoomForm> createState() => _CreateRoomFormState();
}

class _CreateRoomFormState extends ConsumerState<CreateRoomForm> {
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
    final wallet = ref.watch(walletStreamProvider).value;
    final currentBalance = wallet?.talonBalance ?? 0;
    final hasEnoughBalance =
        widget.entryFee <= 0 || currentBalance >= widget.entryFee;

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tournament Entry Fee:', style: AppTextStyles.bodyMd),
                    Text(
                      widget.entryFee > 0 ? '$_entryFeeLabel Talons' : 'FREE',
                      style: AppTextStyles.numberMd.copyWith(
                        color: AppColors.electricCyan,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Your Talon Balance:', style: AppTextStyles.bodyMd),
                    Text(
                      '${currentBalance.toStringAsFixed(0)} T',
                      style: AppTextStyles.numberMd.copyWith(
                        color: hasEnoughBalance
                            ? AppColors.statusSuccess
                            : AppColors.statusError,
                      ),
                    ),
                  ],
                ),
                if (widget.entryFee > 0) ...[
                  const SizedBox(height: AppSpacing.sm),
                  const Divider(color: AppColors.dividerColor),
                  const SizedBox(height: AppSpacing.xs),
                  if (!hasEnoughBalance) ...[
                    Text(
                      'Insufficient Talons balance to register! Please top up your wallet.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.statusError,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SecondaryOutlineButton(
                      text: 'ADD TALONS TO WALLET',
                      onPressed: () => context.pushNamed(RouteNames.addMoney),
                    ),
                  ] else ...[
                    Text(
                      '$_entryFeeLabel Talons will be deducted from your wallet upon room creation.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryGradientButton(
            text: widget.entryFee > 0
                ? 'PAY $_entryFeeLabel T & CREATE ROOM'
                : 'CREATE ROOM (FREE)',
            isLoading: widget.isLoading,
            enabled: hasEnoughBalance && !widget.isLoading,
            leadingIcon: Icon(
              widget.entryFee > 0 ? Icons.payment : Icons.check_circle_outline,
              color: Colors.white,
            ),
            onPressed: widget.isLoading || !hasEnoughBalance ? null : _submit,
          ),
        ],
      ),
    );
  }
}
