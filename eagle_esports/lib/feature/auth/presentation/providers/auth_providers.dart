import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:eagle_esports/feature/auth/data/auth_repository.dart';
import 'package:eagle_esports/feature/auth/presentation/providers/auth_notifier.dart';
import 'package:eagle_esports/models/profile.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthRepository(client);
});

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, Session?>(() {
  return AuthNotifier();
});

final profileProvider = FutureProvider<Profile?>((ref) async {
  final session = ref.watch(authNotifierProvider).value;
  if (session == null) return null;

  final data = await Supabase.instance.client
      .from('profiles')
      .select()
      .eq('id', session.user.id)
      .single();

  return Profile.fromMap(data);
});

final profileByIdProvider = FutureProvider.family<Profile?, String>((
  ref,
  userId,
) async {
  final data = await Supabase.instance.client
      .from('profiles')
      .select()
      .eq('id', userId)
      .maybeSingle();

  if (data == null) return null;
  return Profile.fromMap(data);
});
