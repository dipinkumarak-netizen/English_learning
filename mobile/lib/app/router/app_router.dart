import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/presentation/auth_controller.dart';
import '../../features/authentication/presentation/auth_gate_screen.dart';
import '../../features/authentication/presentation/sign_in_screen.dart';
import '../../features/authentication/presentation/sign_up_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/learning_plan/presentation/learning_plan_screen.dart';
import '../../features/learner_profile/presentation/profile_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/placement_test/presentation/placement_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/error/presentation/error_screen.dart';
import '../../features/courses/presentation/course_details_screen.dart';
import '../../features/courses/presentation/course_library_screen.dart';
import '../../features/courses/presentation/lesson_player_screen.dart';
import '../../features/courses/presentation/progress_summary_screen.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authStateProvider);
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final location = state.matchedLocation;
      if (auth.status == AuthStatus.loading) {
        return location == '/splash' ? null : '/splash';
      }
      final publicRoutes = {'/splash', '/auth', '/signin', '/signup'};
      if (auth.status == AuthStatus.signedOut) {
        return publicRoutes.contains(location) ? null : '/auth';
      }
      if (publicRoutes.contains(location)) {
        return auth.onboardingComplete ? '/home' : '/onboarding';
      }
      if (!auth.onboardingComplete &&
          location != '/onboarding' &&
          location != '/placement') {
        return '/onboarding';
      }
      return null;
    },
    errorBuilder: (context, state) =>
        ErrorScreen(message: state.error?.toString()),
    routes: [
      GoRoute(
        name: RouteNames.splash,
        path: '/splash',
        builder: (_, _) => const SplashScreen(),
      ),
      GoRoute(path: '/auth', builder: (_, _) => const AuthGateScreen()),
      GoRoute(path: '/signin', builder: (_, _) => const SignInScreen()),
      GoRoute(path: '/signup', builder: (_, _) => const SignUpScreen()),
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
      GoRoute(path: '/placement', builder: (_, _) => const PlacementScreen()),
      GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
      GoRoute(
        path: '/learning-plan',
        builder: (_, _) => const LearningPlanScreen(),
      ),
      GoRoute(
        name: RouteNames.home,
        path: '/home',
        builder: (_, _) => const HomeScreen(),
      ),
      GoRoute(path: '/courses', builder: (_, _) => const CourseLibraryScreen()),
      GoRoute(
        path: '/courses/:courseId',
        builder: (_, state) =>
            CourseDetailsScreen(courseId: state.pathParameters['courseId']!),
      ),
      GoRoute(
        path: '/lessons/:lessonId',
        builder: (_, state) =>
            LessonPlayerScreen(lessonId: state.pathParameters['lessonId']!),
      ),
      GoRoute(
        path: '/progress',
        builder: (_, _) => const ProgressSummaryScreen(),
      ),
    ],
  );
});
