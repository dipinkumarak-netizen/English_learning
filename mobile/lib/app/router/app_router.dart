import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../shell/app_shell.dart';
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
import '../../features/courses/presentation/daily_learning_path_screen.dart';
import '../../features/courses/presentation/lesson_player_screen.dart';
import '../../features/courses/presentation/progress_summary_screen.dart';
import '../../features/tutor/presentation/mistake_notebook_screen.dart';
import '../../features/tutor/presentation/tutor_chat_screen.dart';
import '../../features/tutor/presentation/tutor_home_screen.dart';
import '../../features/voice/presentation/voice_conversation_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/settings/presentation/ai_settings_screen.dart';
import '../../features/settings/presentation/migration_screen.dart';
import 'route_names.dart';

String? appRedirect(AuthState auth, String location) {
  if (auth.status == AuthStatus.loading) {
    return location == '/splash' ? null : '/splash';
  }
  if (location == '/splash') {
    return auth.onboardingComplete ? '/dashboard' : '/onboarding';
  }
  if (location == '/home') {
    return auth.onboardingComplete ? '/dashboard' : '/onboarding';
  }
  if (location == '/auth' || location == '/signin' || location == '/signup') {
    return auth.isAuthenticated ? '/home' : null;
  }
  if (!auth.onboardingComplete &&
      location != '/onboarding' &&
      location != '/placement' &&
      location != '/settings' &&
      location != '/migration') {
    return '/onboarding';
  }
  return null;
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authStateProvider);
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) => appRedirect(auth, state.matchedLocation),
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
        path: '/settings/ai',
        builder: (_, _) => const AISettingsScreen(),
      ),
      GoRoute(path: '/migration', builder: (_, _) => const MigrationScreen()),
      GoRoute(
        path: '/learning-plan',
        builder: (_, _) => const LearningPlanScreen(),
      ),
      GoRoute(path: '/home', redirect: (_, _) => '/dashboard'),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: RouteNames.home,
                path: '/dashboard',
                builder: (_, _) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/learn',
                builder: (_, _) => const DailyLearningPathScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tutor',
                builder: (_, _) => const TutorHomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/progress',
                builder: (_, _) => const ProgressSummaryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (_, _) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(path: '/courses', builder: (_, _) => const CourseLibraryScreen()),
      GoRoute(
        path: '/courses/:courseId',
        builder: (_, state) =>
            CourseDetailsScreen(courseId: state.pathParameters['courseId']!),
      ),
      GoRoute(
        path: '/lessons/:lessonId',
        builder: (_, state) => LessonPlayerScreen(
          lessonId: state.pathParameters['lessonId']!,
          dayNumber: int.tryParse(state.uri.queryParameters['day'] ?? ''),
        ),
      ),
      GoRoute(
        path: '/tutor/chat/:conversationId',
        builder: (_, state) => TutorChatScreen(
          conversationId: state.pathParameters['conversationId']!,
        ),
      ),
      GoRoute(
        path: '/tutor/voice/:sessionId',
        builder: (_, state) => VoiceConversationScreen(
          sessionId: state.pathParameters['sessionId']!,
        ),
      ),
      GoRoute(
        path: '/tutor/mistakes',
        builder: (_, _) => const MistakeNotebookScreen(),
      ),
    ],
  );
});
