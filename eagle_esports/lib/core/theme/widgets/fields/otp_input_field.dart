import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_colors.dart';
import '../../app_dimensions.dart';
import '../../app_radius.dart';
import '../../app_spacing.dart';
import '../../app_text_styles.dart';

/// Six-cell OTP input styled as focused HUD input cells.
class OtpInputField extends StatefulWidget {
  const OtpInputField({
    this.length = 6,
    this.onChanged,
    this.onCompleted,
    this.enabled = true,
    super.key,
  });

  final int length;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final bool enabled;

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    for (final focusNode in _focusNodes) {
      focusNode.addListener(_handleCellFocusChanged);
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode
        ..removeListener(_handleCellFocusChanged)
        ..dispose();
    }
    super.dispose();
  }

  void _handleCellFocusChanged() {
    setState(() {});
  }

  void _emitValue() {
    final value = _controllers.map((controller) => controller.text).join();
    widget.onChanged?.call(value);
    if (_controllers.every((controller) => controller.text.isNotEmpty)) {
      widget.onCompleted?.call(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(widget.length, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index == widget.length - 1 ? 0 : AppSpacing.xs,
            ),
            child: SizedBox(
              height: AppDimensions.inputHeight,
              child: Builder(
                builder: (context) {
                  final focused = _focusNodes[index].hasFocus;
                  final filled = _controllers[index].text.isNotEmpty;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      borderRadius: AppRadius.radiusDefault,
                      border: Border.all(
                        color: focused || filled
                            ? AppColors.electricCyan
                            : AppColors.outlineVariant,
                        width: focused
                            ? AppDimensions.focusBorderWidth
                            : AppDimensions.borderWidth,
                      ),
                      boxShadow: focused || filled
                          ? AppColors.glowShadow(
                              AppColors.electricCyan,
                              blur: 6,
                              opacity: 0.35,
                            )
                          : null,
                    ),
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      enabled: widget.enabled,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      textInputAction: index == widget.length - 1
                          ? TextInputAction.done
                          : TextInputAction.next,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(1),
                      ],
                      style: AppTextStyles.numberMd,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < widget.length - 1) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                        setState(_emitValue);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}
