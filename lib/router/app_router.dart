import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../firstscreen/onboarding_flow.dart';
import '../firstscreen/update_password_screen.dart';
import '../firstscreen/pin_settings_screen.dart';
import '../main.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AppLaunchGate(child: MainNavigationScreen()),
      ),
      GoRoute(
        path: '/update-password',
        builder: (context, state) => const UpdatePasswordScreen(),
      ),
      GoRoute(
        path: '/reset-pin',
        builder: (context, state) => const PinSettingsScreen(isRecovery: true),
        redirect: (context, state) {
          final session = Supabase.instance.client.auth.currentSession;
          if (session == null) {
            return '/';
          }
          return null;
        },
      ),
    ],
  );

  static StreamSubscription<AuthState>? _authSubscription;

  static void initializeAuthListener() {
    _authSubscription?.cancel();
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.passwordRecovery) {
        router.go('/reset-pin');
      }
    });
  }
}
