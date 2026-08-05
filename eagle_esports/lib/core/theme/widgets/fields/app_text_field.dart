import 'package:flutter/material.dart';

import '../../app_colors.dart';
import '../../app_decorations.dart';
import '../../app_text_styles.dart';

/// App text field with theme-backed styling and HUD focus glow.
class AppTextField extends StatefulWidget {
  const AppTextField({
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
    this.controller,
    this.enabled = true,
    super.key,
  });

  final String? label;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int maxLines;
  final TextEditingController? controller;
  final bool enabled;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final FocusNode _focusNode;
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_handleFocusChanged);
    _obscured = widget.obscureText;
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChanged)
      ..dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final suffix = widget.obscureText
        ? IconButton(
            onPressed: () => setState(() => _obscured = !_obscured),
            icon: Icon(
              _obscured ? Icons.visibility_off : Icons.visibility,
              color: _obscured ? AppColors.outline : AppColors.electricCyan,
            ),
          )
        : widget.suffixIcon;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: _focusNode.hasFocus
          ? AppDecorations.neonInputFocused()
          : null,
      child: TextFormField(
        controller: widget.controller,
        enabled: widget.enabled,
        focusNode: _focusNode,
        obscureText: _obscured,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        maxLines: widget.obscureText ? 1 : widget.maxLines,
        style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurface),
        decoration: InputDecoration(
          hintText: widget.hint,
          prefixIcon: widget.prefixIcon,
          suffixIcon: suffix,
          hintStyle: TextStyle(
            color: AppColors.onSurface.withValues(alpha: 0.8),
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
