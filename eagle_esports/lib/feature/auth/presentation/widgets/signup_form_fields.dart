import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/splash/widget/form_field_section.dart';
import 'package:flutter/material.dart';

class SignupFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final bool acceptTerms;
  final ValueChanged<bool?> onAcceptTermsChanged;

  const SignupFormFields({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.acceptTerms,
    required this.onAcceptTermsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldSection(
          label: 'Full Name',
          child: AppTextField(
            controller: nameController,
            hint: 'Commander Zero',
            prefixIcon: const Icon(
              Icons.person_outline,
              color: AppColors.primary,
              size: AppDimensions.iconSm,
            ),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Full name is required';
              }
              return null;
            },
          ),
        ),
        FormFieldSection(
          label: 'Email Address',
          child: AppTextField(
            controller: emailController,
            hint: 'zero@eagle.gg',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(
              Icons.alternate_email,
              color: AppColors.primary,
              size: AppDimensions.iconSm,
            ),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Email is required';
              }
              if (!val.contains('@')) {
                return 'Invalid email address';
              }
              return null;
            },
          ),
        ),
        FormFieldSection(
          label: 'Phone Number',
          child: AppTextField(
            controller: phoneController,
            hint: '+1 (555) 000-0000',
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(
              Icons.phone_outlined,
              color: AppColors.primary,
              size: AppDimensions.iconSm,
            ),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Phone number is required';
              }
              return null;
            },
          ),
        ),
        FormFieldSection(
          label: 'Password',
          child: AppTextField(
            controller: passwordController,
            hint: '••••••••••••',
            obscureText: true,
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: AppColors.primary,
              size: AppDimensions.iconSm,
            ),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Password is required';
              }
              if (val.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
        ),

        // Terms agreement checkbox
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: acceptTerms,
                activeColor: AppColors.statusSuccess,
                checkColor: Colors.black,
                side: const BorderSide(
                  color: AppColors.outlineVariant,
                ),
                onChanged: onAcceptTermsChanged,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  onAcceptTermsChanged(!acceptTerms);
                },
                child: Text(
                  'I acknowledge the Terms of Condition and Policies.',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
