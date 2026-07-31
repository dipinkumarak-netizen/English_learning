import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_loading_indicator.dart';
import 'course_providers.dart';

class CourseLibraryScreen extends ConsumerWidget {
  const CourseLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(coursesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Course library')),
      body: courses.when(
        loading: () => const AppLoadingIndicator(),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Unable to load courses.'),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => ref.invalidate(coursesProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (items) => items.isEmpty
            ? const Center(child: Text('No courses are available yet.'))
            : ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final course = items[index];
                  final completion =
                      (course['completion_percentage'] as num?)?.toDouble() ??
                      0;
                  return Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: const CircleAvatar(
                        child: Icon(Icons.menu_book_outlined),
                      ),
                      title: Text(course['title'] as String? ?? 'Course'),
                      subtitle: Text(
                        '${course['learner_level'] ?? 'A1'}  •  ${course['estimated_total_minutes'] ?? 0} minutes\n${course['short_description'] ?? ''}',
                      ),
                      isThreeLine: true,
                      trailing: SizedBox(
                        width: 56,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(value: completion / 100),
                            const SizedBox(height: 2),
                            Text('${completion.round()}%'),
                          ],
                        ),
                      ),
                      onTap: () => context.go('/courses/${course['id']}'),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
