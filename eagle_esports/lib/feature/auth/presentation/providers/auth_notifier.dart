import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:eagle_esports/feature/auth/presentation/providers/auth_providers.dart';

class AuthNotifier extends AsyncNotifier<Session?> {
  StreamSubscription<AuthState>? _authStateSubscription;

  @override
  FutureOr<Session?> build() async {
    final repository = ref.watch(authRepositoryProvider);

    _authStateSubscription?.cancel();
    _authStateSubscription = repository.authStateChanges.listen(
      (authState) {
        state = AsyncValue.data(authState.session);
      },
      onError: (Object error, StackTrace stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      },
    );

    ref.onDispose(() {
      _authStateSubscription?.cancel();
    });

    // Ensure splash screen is visible for at least 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    final session = repository.currentSession;
    return session;
  }

  Future<void> signIn(String email, String password) async {
    final repository = ref.read(authRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await repository.signIn(email, password);
      return repository.currentSession;
    });
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    final repository = ref.read(authRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await repository.signUp(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
      );
      return repository.currentSession;
    });
  }

  Future<void> signOut() async {
    final repository = ref.read(authRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await repository.signOut();
      return null;
    });
  }
}
