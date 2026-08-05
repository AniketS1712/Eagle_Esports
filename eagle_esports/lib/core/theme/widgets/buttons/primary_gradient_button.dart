import 'package:flutter/material.dart';

import '../../app_colors.dart';
import '../../app_dimensions.dart';
import '../../app_radius.dart';
import '../../app_spacing.dart';
import '../../app_text_styles.dart';

/// Full-width primary action with the Eagle Esport electric blue/cyan gradient.
class PrimaryGradientButton extends StatelessWidget {
  const PrimaryGradientButton({
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.leadingIcon,
    this.enabled = true,
    super.key,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? leadingIcon;
  final bool enabled;

  bool get _canPress => enabled && !isLoading && onPressed != null;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.primaryButtonGradient,
          borderRadius: AppRadius.radiusXl,
          boxShadow: enabled
              ? AppColors.glowShadow(
                  AppColors.electricCyan,
                  blur: 15,
                  opacity: 0.4,
                )
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _canPress ? onPressed : null,
            borderRadius: AppRadius.radiusDefault,
            child: SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : _ButtonLabel(text: text, leadingIcon: leadingIcon),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ButtonLabel extends StatelessWidget {
  const _ButtonLabel({
    required this.text,
    this.leadingIcon,
  });

  final String text;
  final Widget? leadingIcon;

  @override
  Widget build(BuildContext context) {
    final label = Text(
      text.toUpperCase(),
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.labelMd.copyWith(color: Colors.black, letterSpacing: 1.5),
    );

    if (leadingIcon == null) {
      return label;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        leadingIcon!,
        const SizedBox(width: AppSpacing.xs),
        Flexible(child: label),
      ],
    );
  }
}
