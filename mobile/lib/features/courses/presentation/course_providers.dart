import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authentication/presentation/auth_controller.dart';
import '../data/course_repository.dart';

final courseRepositoryProvider = Provider<CourseRepository>(
  (ref) => CourseRepository(
    ref.watch(apiClientProvider),
    ref.watch(databaseProvider),
    () => ref.read(tokenStorageProvider).readAccessToken(),
  ),
);

final coursesProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>(
  (ref) => ref.watch(courseRepositoryProvider).courses(),
);

final courseDetailsProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, String>(
      (ref, courseId) => ref.watch(courseRepositoryProvider).course(courseId),
    );

final lessonDetailsProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, String>(
      (ref, lessonId) => ref.watch(courseRepositoryProvider).lesson(lessonId),
    );

final progressSummaryProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
      final token = await ref.read(tokenStorageProvider).readAccessToken();
      if (token == null) throw StateError('No session');
      return ref
          .read(apiClientProvider)
          .get('/api/v1/progress/summary', accessToken: token);
    });
