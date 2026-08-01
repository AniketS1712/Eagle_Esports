import 'package:flutter/material.dart';
import 'package:eagle_esports/core/routes/router.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://nqpfewhunbrkdofmbdiu.supabase.co',
    publishableKey: 'sb_publishable_CMd_7wETWt1NUZ1FiQ81bQ_Fkh-i7nE',
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'Eagle Esports',
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: goRouter,
    );
  }
}
