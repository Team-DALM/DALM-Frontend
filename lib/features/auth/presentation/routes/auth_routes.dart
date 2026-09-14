import 'package:dalm/app/router/app_routes.dart';
import 'package:dalm/features/auth/presentation/views/login_screen.dart';
import 'package:dalm/features/onboarding/presentation/views/onboarding_screen.dart';
import 'package:dalm/features/onboarding/presentation/views/splash_screen.dart';
import 'package:go_router/go_router.dart';

final authRootRoutes = <RouteBase>[
  GoRoute(
    path: AppRoutes.splash,
    builder: (context, state) {
      return const SplashScreen();
    },
  ),
  GoRoute(
    path: AppRoutes.onboarding,
    builder: (context, state) {
      return const OnboardingScreen();
    },
  ),
  GoRoute(
    path: AppRoutes.login,
    builder: (context, state) {
      return const LoginScreen();
    },
  ),
];
