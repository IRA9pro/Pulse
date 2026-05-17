import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/services/supabase_service.dart';
import 'core/services/auth_provider.dart';
import 'core/theme/pulse_theme.dart';
import 'system/auth/login_screen.dart';
import 'system/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseService.init();

  runApp(
    const ProviderScope(
      child: PulseApp(),
    ),
  );
}

class PulseApp extends ConsumerWidget {
  const PulseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final isRegistering = ref.watch(registrationInProgressProvider);

    return MaterialApp(
      title: 'Pulse',
      debugShowCheckedModeBanner: false,
      theme: PulseTheme.darkTheme,
      home: authState.when(
        data: (state) {
          // Only show HomeScreen if authenticated AND not currently in the middle of registration steps
          if (state.session != null && !isRegistering) {
            return const HomeScreen();
          }
          return const LoginScreen();
        },
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator(color: PulseTheme.neonCyan)),
        ),
        error: (e, _) => const LoginScreen(),
      ),
    );
  }
}
