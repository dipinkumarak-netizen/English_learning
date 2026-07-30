import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/welcome/presentation/welcome_screen.dart';
import '../../features/error/presentation/error_screen.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    errorBuilder: (context, state) =>
        ErrorScreen(message: state.error?.toString()),
    routes: [
      GoRoute(
        name: RouteNames.splash,
        path: '/splash',
        builder: (_, _) => const SplashScreen(),
      ),
      GoRoute(
        name: RouteNames.welcome,
        path: '/welcome',
        builder: (_, _) => const WelcomeScreen(),
      ),
      GoRoute(
        name: RouteNames.home,
        path: '/home',
        builder: (_, _) => const HomeScreen(),
      ),
    ],
  );
});
