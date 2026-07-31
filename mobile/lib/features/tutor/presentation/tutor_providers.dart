import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authentication/presentation/auth_controller.dart';
import '../../courses/presentation/course_providers.dart';
import '../data/tutor_repository.dart';

final tutorRepositoryProvider = Provider<TutorRepository>(
  (ref) => TutorRepository(
    ref.watch(apiClientProvider),
    ref.watch(databaseProvider),
    () => ref.read(tokenStorageProvider).readAccessToken(),
  ),
);

final tutorConversationsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>(
      (ref) => ref.watch(tutorRepositoryProvider).conversations(),
    );

final tutorMessagesProvider = FutureProvider.autoDispose
    .family<List<Map<String, dynamic>>, String>(
      (ref, conversationId) =>
          ref.watch(tutorRepositoryProvider).messages(conversationId),
    );

final tutorUsageProvider = FutureProvider.autoDispose<Map<String, dynamic>>(
  (ref) => ref.watch(tutorRepositoryProvider).usage(),
);

final tutorMistakesProvider = FutureProvider.autoDispose<Map<String, dynamic>>(
  (ref) => ref.watch(tutorRepositoryProvider).mistakes(),
);
