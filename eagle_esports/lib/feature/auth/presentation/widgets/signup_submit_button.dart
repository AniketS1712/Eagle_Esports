import 'package:eagle_esports/core/theme/theme.dart';
import 'package:flutter/material.dart';

class SignupSubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const SignupSubmitButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryGradientButton(
      text: 'Create Account',
      isLoading: isLoading,
      leadingIcon: const Icon(
        Icons.chevron_right,
        color: Colors.white,
        size: AppDimensions.iconSm,
      ),
      onPressed: onPressed,
    );
  }
}
