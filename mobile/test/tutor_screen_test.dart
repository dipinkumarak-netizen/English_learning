import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nilaspeak_mobile/features/tutor/presentation/mistake_notebook_screen.dart';
import 'package:nilaspeak_mobile/features/tutor/presentation/tutor_chat_screen.dart';
import 'package:nilaspeak_mobile/features/tutor/presentation/tutor_home_screen.dart';
import 'package:nilaspeak_mobile/features/tutor/presentation/tutor_providers.dart';
import 'package:nilaspeak_mobile/features/authentication/presentation/auth_controller.dart';

void main() {
  testWidgets('local tutor requires sign-in', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: TutorHomeScreen())),
    );
    await tester.pumpAndSettle();
    expect(find.text('Sign in to use the AI Tutor'), findsOneWidget);
    expect(find.text('Not now'), findsOneWidget);
  });

  testWidgets('tutor home renders usage and new-practice controls', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tutorConversationsProvider.overrideWith((_) async => const []),
          tutorUsageProvider.overrideWith(
            (_) async => {'requests_today': 1, 'daily_request_limit': 50},
          ),
          authStateProvider.overrideWith((ref) {
            final controller = AuthController(
              ref.read(authRepositoryProvider),
              ref.read(databaseProvider),
            );
            controller.state = const AuthState(
              status: AuthStatus.signedIn,
              onboardingComplete: true,
            );
            return controller;
          }),
        ],
        child: const MaterialApp(home: TutorHomeScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('AI English tutor'), findsOneWidget);
    expect(find.text('Start practice'), findsOneWidget);
  });

  testWidgets('chat renders cached messages and composer', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tutorMessagesProvider('conversation-1').overrideWith(
            (_) async => [
              {
                'id': 'message-1',
                'role': 'tutor',
                'tutor_reply': 'Try a short sentence.',
                'structured_response': {
                  'explanation_ml': 'ഒരു ചെറിയ വാക്യം എഴുതൂ.',
                },
              },
            ],
          ),
        ],
        child: const MaterialApp(
          home: TutorChatScreen(conversationId: 'conversation-1'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Try a short sentence.'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('mistake notebook renders cached correction', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tutorMistakesProvider.overrideWith(
            (_) async => {
              'mistakes': [
                {
                  'id': 'mistake-1',
                  'corrected_sentence': 'I am ready.',
                  'mistake_category': 'tense',
                  'repeat_count': 1,
                  'mastered': false,
                },
              ],
            },
          ),
        ],
        child: const MaterialApp(home: MistakeNotebookScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('I am ready.'), findsOneWidget);
    expect(find.byTooltip('Mark mastered'), findsOneWidget);
  });
}
