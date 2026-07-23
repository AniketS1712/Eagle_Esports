import 'package:eagle_esports/core/routes/route_path.dart';
import 'package:eagle_esports/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eagle_esports/core/routes/app_routes.dart';
import 'package:eagle_esports/feature/auth/presentation/providers/auth_providers.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ValueNotifier<int>(0);

  // Any change to either provider just bumps a counter to trigger
  // GoRouter to re-run `redirect`. We don't store the actual value
  // here — `redirect` always reads the freshest state via ref.read.
  ref.listen(authNotifierProvider, (previous, next) {
    notifier.value++;
  });
  ref.listen(profileProvider, (previous, next) {
    notifier.value++;
  });

  return GoRouter(
    initialLocation: RoutePath.splash,
    refreshListenable: notifier,
    routes: appRoutes,
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      final isAuthRoute = [
        RoutePath.login,
        RoutePath.signup,
        RoutePath.forgotPassword,
        RoutePath.otp,
      ].contains(state.matchedLocation);
      final isGoingToSplash = state.matchedLocation == RoutePath.splash;

      // --- Auth still resolving (first load only) ---
      // hasValue is false only before the first successful/errored
      // emission — a later background refresh won't bounce us back
      // here, since by then hasValue is already true.
      if (!authState.hasValue && !authState.hasError) {
        if (isGoingToSplash || isAuthRoute) return null;
        return RoutePath.splash;
      }

      if (authState.hasError) {
        // Treat an auth-check failure as logged-out; don't trap the
        // user on splash indefinitely.
        if (isAuthRoute) return null;
        return RoutePath.login;
      }

      final session = authState.value;
      final isAuth = session != null;

      if (!isAuth) {
        if (isAuthRoute) return null;
        return RoutePath.login;
      }

      // --- Authenticated: profile must resolve before proceeding ---
      final profileState = ref.read(profileProvider);

      if (!profileState.hasValue && !profileState.hasError) {
        if (isGoingToSplash) return null;
        return RoutePath.splash;
      }

      if (profileState.hasError) {
        // Profile fetch failed for a logged-in user — send to splash
        // rather than guessing a role; splash UI can show a retry
        // affordance if this persists.
        return isGoingToSplash ? null : RoutePath.splash;
      }

      final profile = profileState.value;

      if (profile == null) {
        // Authenticated but no profile row yet (e.g. trigger lag
        // right after signup). Hold on splash briefly rather than
        // routing into a screen that assumes profile data exists.
        return isGoingToSplash ? null : RoutePath.splash;
      }

      if (profile.isBanned) {
        return state.matchedLocation == RoutePath.accountBanned
            ? null
            : RoutePath.accountBanned;
      }

      if (isAuthRoute || isGoingToSplash) {
        return profile.role == UserRole.organiser
            ? RoutePath.organiserDashboard
            : RoutePath.home;
      }

      return null;
    },
  );
});
