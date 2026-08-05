import 'package:flutter/material.dart';

import '../../app_colors.dart';
import '../../app_dimensions.dart';
import '../../app_spacing.dart';
import '../../app_text_styles.dart';

/// Secondary outlined action using the app-wide outlined button theme.
class SecondaryOutlineButton extends StatelessWidget {
  const SecondaryOutlineButton({
    required this.text,
    required this.onPressed,
    this.leadingIcon,
    super.key,
  });

  final String text;
  final VoidCallback? onPressed;
  final Widget? leadingIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppDimensions.buttonHeight,
      child: OutlinedButton(
        onPressed: onPressed,
        child: _ButtonLabel(
          text: text,
          leadingIcon: leadingIcon,
          color: AppColors.electricCyan,
        ),
      ),
    );
  }
}

class _ButtonLabel extends StatelessWidget {
  const _ButtonLabel({
    required this.text,
    this.leadingIcon,
    this.color = Colors.black,
  });

  final String text;
  final Widget? leadingIcon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final label = Text(
      text.toUpperCase(),
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.labelMd.copyWith(color: color, letterSpacing: 1.5),
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
