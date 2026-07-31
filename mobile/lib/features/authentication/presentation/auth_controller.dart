import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../data/auth_repository.dart';
import '../data/token_storage.dart';

enum AuthStatus { loading, signedOut, signedIn }

class AuthState {
  const AuthState({
    required this.status,
    this.user,
    this.onboardingComplete = false,
    this.error,
  });
  final AuthStatus status;
  final Map<String, dynamic>? user;
  final bool onboardingComplete;
  final String? error;
}

final tokenStorageProvider = Provider<TokenStorage>(
  (ref) => SecureTokenStorage(),
);
final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(tokens: ref.watch(tokenStorageProvider)),
);
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    ref.watch(apiClientProvider),
    ref.watch(tokenStorageProvider),
  ),
);
final authStateProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(ref.watch(authRepositoryProvider))..restore(),
);

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._repository)
    : super(const AuthState(status: AuthStatus.loading));
  final AuthRepository _repository;

  Future<void> restore() async {
    try {
      final profile = await _repository.profile();
      state = AuthState(
        status: AuthStatus.signedIn,
        user: profile,
        onboardingComplete: profile['onboarding_complete'] as bool? ?? false,
      );
    } catch (_) {
      state = const AuthState(status: AuthStatus.signedOut);
    }
  }

  Future<void> signIn(String email, String password) async {
    state = const AuthState(status: AuthStatus.loading);
    try {
      final response = await _repository.login(
        email: email,
        password: password,
      );
      state = AuthState(
        status: AuthStatus.signedIn,
        user: response['user'] as Map<String, dynamic>?,
        onboardingComplete: false,
      );
    } catch (error) {
      state = AuthState(status: AuthStatus.signedOut, error: error.toString());
      rethrow;
    }
  }

  Future<void> signUp(String email, String password, String displayName) async {
    state = const AuthState(status: AuthStatus.loading);
    try {
      final response = await _repository.register(
        email: email,
        password: password,
        displayName: displayName,
      );
      state = AuthState(
        status: AuthStatus.signedIn,
        user: response['user'] as Map<String, dynamic>?,
        onboardingComplete: false,
      );
    } catch (error) {
      state = AuthState(status: AuthStatus.signedOut, error: error.toString());
      rethrow;
    }
  }

  Future<void> markOnboardingComplete() async {
    state = AuthState(
      status: AuthStatus.signedIn,
      user: state.user,
      onboardingComplete: true,
    );
  }

  Future<void> signOut() async {
    await _repository.logout();
    state = const AuthState(status: AuthStatus.signedOut);
  }
}
