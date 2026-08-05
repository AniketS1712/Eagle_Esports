import 'package:flutter/material.dart';

import '../../app_colors.dart';
import '../../app_dimensions.dart';
import '../../app_radius.dart';
import '../../app_spacing.dart';
import '../../app_text_styles.dart';

/// Destructive action button for irreversible tournament/admin flows.
class DangerButton extends StatelessWidget {
  const DangerButton({
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
          gradient: const LinearGradient(
            colors: [AppColors.statusError, Color(0xFFCC2F26)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: AppRadius.radiusDefault,
          boxShadow: enabled
              ? AppColors.glowShadow(
                  AppColors.statusError,
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
