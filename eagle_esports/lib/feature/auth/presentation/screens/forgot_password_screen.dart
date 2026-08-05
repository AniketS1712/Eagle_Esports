import 'package:eagle_esports/feature/splash/widget/form_field_section.dart';
import 'package:eagle_esports/shared/widgets/eagle_logo.dart';
import 'package:flutter/material.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        await Supabase.instance.client.auth.resetPasswordForEmail(
          _emailController.text.trim(),
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset link sent to your email.'),
            backgroundColor: AppColors.statusSuccess,
          ),
        );
        context.pop();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.statusError,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const EagleLogo(
                    showGlow: false,
                    logoSize: 100,
                    subtitle: 'RESET SECURITY KEY',
                    showLogo: false,
                  ),
                  const SizedBox(height: AppSpacing.xxxl),

                  Form(
                    key: _formKey,
                    child: GlassCard(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FormFieldSection(
                            label: 'Email Address',
                            child: AppTextField(
                              controller: _emailController,
                              hint: 'Enter your email',
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
                          const SizedBox(height: AppSpacing.xxl),

                          PrimaryGradientButton(
                            text: 'Send Reset Link',
                            isLoading: _isLoading,
                            onPressed: _handleReset,
                          ),
                        ],
                      ),
                    ),
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
