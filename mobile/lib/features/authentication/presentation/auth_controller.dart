import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import 'dart:convert';
import 'package:drift/drift.dart';

import '../../../core/network/api_client.dart';
import '../../../core/local/app_database.dart';
import '../data/auth_repository.dart';
import '../data/token_storage.dart';

enum AuthStatus { loading, local, signedOut, signedIn }

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
  bool get isAuthenticated => status == AuthStatus.signedIn;
  bool get isLocal =>
      status == AuthStatus.local || status == AuthStatus.signedOut;
}

final _sharedDatabase = AppDatabase();
final databaseProvider = Provider<AppDatabase>((ref) => _sharedDatabase);
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
  (ref) => AuthController(
    ref.watch(authRepositoryProvider),
    ref.watch(databaseProvider),
  )..restore(),
);

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._repository, this._database)
    : super(const AuthState(status: AuthStatus.loading));
  final AuthRepository _repository;
  final AppDatabase _database;

  Future<void> restore() async {
    var local = await _database.localProfile();
    if (local == null) {
      final now = DateTime.now();
      local = LocalLearnerProfile(
        id: _uuid(),
        displayName: 'Learner',
        nativeLanguage: 'ml',
        explanationLanguage: 'ml',
        confidenceLevel: null,
        learningGoals: '[]',
        difficultAreas: '[]',
        dailyStudyMinutes: null,
        onboardingComplete: false,
        placementResult: null,
        learningPlanSummary: null,
        createdAt: now,
        updatedAt: now,
      );
      await _database.saveLocalProfile(
        LocalLearnerProfilesCompanion.insert(
          id: local.id,
          displayName: Value(local.displayName),
          nativeLanguage: Value(local.nativeLanguage),
          explanationLanguage: Value(local.explanationLanguage),
          confidenceLevel: const Value.absent(),
          learningGoals: Value(local.learningGoals),
          difficultAreas: Value(local.difficultAreas),
          dailyStudyMinutes: const Value.absent(),
          onboardingComplete: Value(local.onboardingComplete),
          placementResult: const Value.absent(),
          learningPlanSummary: const Value.absent(),
          createdAt: local.createdAt,
          updatedAt: local.updatedAt,
        ),
      );
    }
    try {
      final profile = await _repository.profile();
      state = AuthState(
        status: AuthStatus.signedIn,
        user: profile,
        onboardingComplete: profile['onboarding_complete'] as bool? ?? false,
      );
    } catch (_) {
      await _repository.clearTokens();
      state = AuthState(
        status: AuthStatus.local,
        onboardingComplete: local.onboardingComplete,
      );
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

  Future<void> markLocalOnboardingComplete() async {
    final profile = await _database.localProfile();
    if (profile == null) return;
    await _database.saveLocalProfile(
      LocalLearnerProfilesCompanion.insert(
        id: profile.id,
        displayName: Value(profile.displayName),
        nativeLanguage: Value(profile.nativeLanguage),
        explanationLanguage: Value(profile.explanationLanguage),
        confidenceLevel: Value(profile.confidenceLevel),
        learningGoals: Value(profile.learningGoals),
        difficultAreas: Value(profile.difficultAreas),
        dailyStudyMinutes: Value(profile.dailyStudyMinutes),
        onboardingComplete: const Value(true),
        placementResult: Value(profile.placementResult),
        learningPlanSummary: Value(profile.learningPlanSummary),
        createdAt: profile.createdAt,
        updatedAt: DateTime.now(),
      ),
    );
    state = AuthState(status: AuthStatus.local, onboardingComplete: true);
  }

  Future<void> updateLocalProfile(Map<String, dynamic> values) async {
    final profile = await _database.localProfile();
    if (profile == null) return;
    await _database.saveLocalProfile(
      LocalLearnerProfilesCompanion.insert(
        id: profile.id,
        displayName: Value(
          values['display_name'] as String? ?? profile.displayName,
        ),
        nativeLanguage: Value(
          values['native_language'] as String? ?? profile.nativeLanguage,
        ),
        explanationLanguage: Value(
          values['explanation_language'] as String? ??
              profile.explanationLanguage,
        ),
        confidenceLevel: Value(
          values['confidence_level'] as String? ?? profile.confidenceLevel,
        ),
        learningGoals: Value(
          jsonEncode(
            values['learning_goals'] ?? jsonDecode(profile.learningGoals),
          ),
        ),
        difficultAreas: Value(
          jsonEncode(
            values['difficult_areas'] ?? jsonDecode(profile.difficultAreas),
          ),
        ),
        dailyStudyMinutes: Value(
          values['daily_study_minutes'] as int? ?? profile.dailyStudyMinutes,
        ),
        onboardingComplete: Value(
          values['onboarding_complete'] as bool? ?? profile.onboardingComplete,
        ),
        placementResult: Value(profile.placementResult),
        learningPlanSummary: Value(profile.learningPlanSummary),
        createdAt: profile.createdAt,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> resetLocalData() async {
    await _database.resetLocalLearningData();
    await restore();
  }

  Future<void> signOut() async {
    try {
      await _repository.logout();
    } catch (_) {
      await _repository.clearTokens();
    }
    final profile = await _database.localProfile();
    state = AuthState(
      status: AuthStatus.local,
      onboardingComplete: profile?.onboardingComplete ?? false,
    );
  }
}

String _uuid() {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  final hex = bytes
      .map((value) => value.toRadixString(16).padLeft(2, '0'))
      .join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
}
