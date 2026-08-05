import 'dart:async';
import 'package:eagle_esports/core/routes/route_path.dart';
import 'package:eagle_esports/feature/auth/presentation/providers/auth_providers.dart';
import 'package:eagle_esports/feature/splash/widget/corner_hud.dart';
import 'package:eagle_esports/shared/widgets/eagle_logo.dart';
import 'package:eagle_esports/shared/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  int _activeSegment = 0;
  late Timer _loadingTimer;

  bool _minDelayElapsed = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    // Pulse/Animate the segmented loading cells
    _loadingTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (mounted) {
        setState(() {
          _activeSegment = (_activeSegment + 1) % 8;
        });
      }
    });

    // Minimum branding display time — independent of how fast/slow
    // auth and profile resolve.
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _minDelayElapsed = true);
        _maybeNavigate();
      }
    });
  }

  @override
  void dispose() {
    _loadingTimer.cancel();
    super.dispose();
  }

  /// Nudges the router once both the minimum delay has passed AND
  /// auth/profile state has resolved (success or error — we don't
  /// want to navigate while either is still genuinely loading).
  /// The actual destination is decided entirely by `redirect` in
  /// the router — this just triggers it to run again.
  void _maybeNavigate() {
    if (_navigated || !_minDelayElapsed) return;

    final authState = ref.read(authNotifierProvider);
    if (!authState.hasValue && !authState.hasError) return;

    // Always check profile — session might exist but profile still loading
    final profileState = ref.read(profileProvider);
    if (!profileState.hasValue && !profileState.hasError) return;

    _navigated = true;
    // go() triggers the router redirect — redirect decides the real
    // destination based on role. pushNamed() bypasses redirect entirely.
    context.go(RoutePath.home);
  }

  @override
  Widget build(BuildContext context) {
    // Watching (not reading) so this widget rebuilds as auth/profile
    // resolve, which lets _maybeNavigate fire as soon as they're ready
    // (in addition to the 3-second timer callback above).
    ref.listen(authNotifierProvider, (previous, next) {
      _maybeNavigate();
    });
    ref.listen(profileProvider, (previous, next) {
      _maybeNavigate();
    });

    return Scaffold(
      body: AppBackground(
        child: Stack(
          children: [
            // Corner HUD Accents
            const Positioned(
              top: 56,
              left: 32,
              child: CornerHud(top: true, left: true),
            ),
            const Positioned(
              top: 56,
              right: 32,
              child: CornerHud(top: true, right: true),
            ),
            const Positioned(
              bottom: 40,
              left: 32,
              child: CornerHud(bottom: true, left: true),
            ),
            const Positioned(
              bottom: 40,
              right: 32,
              child: CornerHud(bottom: true, right: true),
            ),
            // Main Content
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: const EagleLogo(
                  subtitle: 'Initiating Systems',
                  logoSize: 180,
                  showGlow: true,
                ),
              ),
            ),
            // Loading indicator at bottom
            Positioned(
              bottom: 64,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  // Segmented Progress Cells
                  SegmentedLoader(activeSegment: _activeSegment),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
