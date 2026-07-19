import 'package:go_router/go_router.dart';
import '../firstscreen/onboarding_flow.dart';
import '../main.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) =>
            const AppLaunchGate(child: MainNavigationScreen()),
      ),
    ],
  );

  static void initializeAuthListener() {
    // Không còn dùng deep link cho OTP nữa.
  }
}
