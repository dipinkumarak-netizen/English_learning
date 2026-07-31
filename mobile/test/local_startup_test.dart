import 'package:flutter_test/flutter_test.dart';
import 'package:nilaspeak_mobile/app/router/app_router.dart';
import 'package:nilaspeak_mobile/features/authentication/presentation/auth_controller.dart';

void main() {
  test('local incomplete bootstrap goes to onboarding, never sign-in', () {
    const state = AuthState(status: AuthStatus.local);
    expect(appRedirect(state, '/splash'), '/onboarding');
    expect(appRedirect(state, '/home'), '/onboarding');
    expect(appRedirect(state, '/signin'), isNull);
  });

  test('completed local profile goes to dashboard', () {
    const state = AuthState(status: AuthStatus.local, onboardingComplete: true);
    expect(appRedirect(state, '/splash'), '/dashboard');
    expect(appRedirect(state, '/home'), '/dashboard');
  });

  test('loading bootstrap stays on splash', () {
    const state = AuthState(status: AuthStatus.loading);
    expect(appRedirect(state, '/home'), '/splash');
    expect(appRedirect(state, '/splash'), isNull);
  });
}
