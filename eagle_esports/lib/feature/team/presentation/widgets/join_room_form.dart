import 'package:eagle_esports/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JoinRoomForm extends StatefulWidget {
  const JoinRoomForm({
    required this.onSubmit,
    required this.isLoading,
    super.key,
  });

  final void Function(String inviteCode) onSubmit;
  final bool isLoading;

  @override
  State<JoinRoomForm> createState() => _JoinRoomFormState();
}

class _JoinRoomFormState extends State<JoinRoomForm> {
  static const _codeLength = 6;

  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  bool _showError = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_codeLength, (_) => TextEditingController());
    _focusNodes = List.generate(_codeLength, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  String get _inviteCode {
    return _controllers.map((controller) => controller.text).join();
  }

  bool get _isComplete {
    return _controllers.every((controller) => controller.text.isNotEmpty);
  }

  void _submit() {
    if (widget.isLoading) return;

    if (!_isComplete) {
      setState(() => _showError = true);
      return;
    }

    setState(() => _showError = false);
    widget.onSubmit(_inviteCode);
  }

  void _handleChanged(String value, int index) {
    final uppercaseValue = value.toUpperCase();
    final controller = _controllers[index];

    if (controller.text != uppercaseValue) {
      controller.value = TextEditingValue(
        text: uppercaseValue,
        selection: TextSelection.collapsed(offset: uppercaseValue.length),
      );
    }

    if (uppercaseValue.isNotEmpty && index < _codeLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    if (uppercaseValue.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    if (_isComplete) {
      _submit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_codeLength, (index) {
            return SizedBox(
              width: 48,
              height: 56,
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                enabled: !widget.isLoading,
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.characters,
                maxLength: 1,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
                ],
                style: AppTextStyles.numberMd,
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: AppColors.inputBackground,
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadius.radiusDefault,
                    borderSide: const BorderSide(
                      color: AppColors.outlineVariant,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppRadius.radiusDefault,
                    borderSide: const BorderSide(
                      color: AppColors.electricCyan,
                      width: 1.5,
                    ),
                  ),
                ),
                onChanged: (value) => _handleChanged(value, index),
              ),
            );
          }),
        ),
        if (_showError) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Enter the full 6-character room code',
            style: AppTextStyles.caption.copyWith(color: AppColors.statusError),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        PrimaryGradientButton(
          text: 'JOIN ROOM',
          isLoading: widget.isLoading,
          leadingIcon: const Icon(Icons.login, color: Colors.white),
          onPressed: widget.isLoading ? null : _submit,
        ),
      ],
    );
  }
}
