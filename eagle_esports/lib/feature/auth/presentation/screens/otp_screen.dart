import 'package:eagle_esports/shared/widgets/eagle_logo.dart';
import 'package:flutter/material.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool _isLoading = false;
  String _otp = '';

  Future<void> _handleVerify() async {
    if (_otp.length == 6) {
      setState(() {
        _isLoading = true;
      });

      try {
        await Supabase.instance.client.auth.verifyOTP(
          email: widget.email,
          token: _otp,
          type: OtpType.signup, // or magiclink, depends on usage
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification successful.'),
            backgroundColor: AppColors.statusSuccess,
          ),
        );
        // Let GoRouter redirection handle the navigation to home
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 6-digit code.'),
          backgroundColor: AppColors.statusWarning,
        ),
      );
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
                    subtitle: 'VERIFY IDENTITY',
                    showLogo: false,
                  ),
                  const SizedBox(height: AppSpacing.xxxl),

                  GlassCard(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Enter the 6-digit code sent to\n${widget.email}',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMd.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        // Using the existing OtpInputField from the theme widgets
                        OtpInputField(
                          onCompleted: (val) {
                            setState(() {
                              _otp = val;
                            });
                          },
                          onChanged: (val) {
                            _otp = val;
                          },
                        ),
                        const SizedBox(height: AppSpacing.xxl),

                        PrimaryGradientButton(
                          text: 'Verify',
                          isLoading: _isLoading,
                          onPressed: _handleVerify,
                        ),
                      ],
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
