import 'dart:async';
import 'package:eagle_esports/core/routes/route_names.dart';
import 'package:eagle_esports/feature/splash/widget/form_field_section.dart';
import 'package:eagle_esports/shared/widgets/eagle_logo.dart';
import 'package:flutter/material.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eagle_esports/feature/auth/presentation/providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identityController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _identityController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      final email = _identityController.text.trim();
      final password = _passwordController.text;

      await ref.read(authNotifierProvider.notifier).signIn(email, password);

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
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo + Title Shell
                  EagleLogo(
                    showGlow: false,
                    logoSize: 120,
                    subtitle: 'COMMAND CENTER LOGIN',
                  ),
                  const SizedBox(height: AppSpacing.xxxl),

                  // Login Form in Glass Card
                  Form(
                    key: _formKey,
                    child: GlassCard(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User Identity Field
                          FormFieldSection(
                            label: 'User Identity',
                            child: AppTextField(
                              controller: _identityController,
                              hint: 'Email or Phone Number',
                              prefixIcon: const Icon(
                                Icons.person_outline,
                                color: AppColors.primary,
                                size: AppDimensions.iconSm,
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Identity is required';
                                }
                                return null;
                              },
                            ),
                          ),

                          FormFieldSection(
                            label: 'Password',
                            child: AppTextField(
                              controller: _passwordController,
                              hint: '••••••••••••',
                              obscureText: true,
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: AppColors.primary,
                                size: AppDimensions.iconSm,
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Security key is required';
                                }
                                return null;
                              },
                            ),
                          ),

                          // Security Key Field
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context.pushNamed(RouteNames.forgotPassword);
                                },
                                child: Text(
                                  'FORGOT PASSWORD?',
                                  style: AppTextStyles.linkText.copyWith(
                                    fontSize: 10,
                                    color: AppColors.secondary,
                                    letterSpacing: 1,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xxl),

                          // Submit Button
                          PrimaryGradientButton(
                            text: 'Login',
                            isLoading: _isLoading,
                            onPressed: _handleLogin,
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
                        "DON'T HAVE AN ACCOUNT?",
                        style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      InkWell(
                        onTap: () => context.pushNamed(RouteNames.signup),
                        child: Text(
                          'SIGN UP',
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
