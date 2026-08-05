import 'dart:async';
import 'package:eagle_esports/core/routes/route_names.dart';
import 'package:eagle_esports/feature/auth/presentation/widgets/signup_form_fields.dart';
import 'package:eagle_esports/feature/auth/presentation/widgets/signup_submit_button.dart';
import 'package:eagle_esports/shared/widgets/eagle_logo.dart';
import 'package:flutter/material.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eagle_esports/feature/auth/presentation/providers/auth_providers.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _acceptTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please accept the Terms & Conditions'),
            backgroundColor: AppColors.statusError,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final fullName = _nameController.text.trim();
      final phone = _phoneController.text.trim();

      await ref
          .read(authNotifierProvider.notifier)
          .signUp(
            email: email,
            password: password,
            fullName: fullName,
            phone: phone,
          );

      // Let GoRouter redirect to home if successful, but usually signup logs in as well.
      // If it requires email confirmation, we might need to show a message.
      if (!ref.read(authNotifierProvider).hasError) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Profile Created. Please verify your email with the code sent.',
            ),
            backgroundColor: AppColors.statusSuccess,
          ),
        );
        // Navigate to OTP screen
        context.pushNamed(RouteNames.otp, queryParameters: {'email': email});
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authNotifierProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: AppColors.statusError,
          ),
        );
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.lg,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Brand Header
                  const Column(
                    children: [
                      EagleLogo(
                        showGlow: false,
                        subtitle: 'Create Your Profile',
                        showLogo: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // Signup Glass Card Form
                  Form(
                    key: _formKey,
                    child: GlassCard(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SignupFormFields(
                            nameController: _nameController,
                            emailController: _emailController,
                            phoneController: _phoneController,
                            passwordController: _passwordController,
                            acceptTerms: _acceptTerms,
                            onAcceptTermsChanged: (val) {
                              setState(() {
                                _acceptTerms = val ?? false;
                              });
                            },
                          ),
                          const SizedBox(height: AppSpacing.lg),

                          // Submit Button
                          SignupSubmitButton(
                            isLoading: _isLoading,
                            onPressed: _handleSignup,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Footer Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ALREADY ENLISTED?',
                        style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      InkWell(
                        onTap: () => context.pushNamed(RouteNames.login),
                        child: Text(
                          'LOGIN SECURELY',
                          style: AppTextStyles.linkText.copyWith(
                            fontSize: 12,
                            color: AppColors.secondary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
