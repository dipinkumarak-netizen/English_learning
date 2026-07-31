import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_error_view.dart';
import '../../../core/widgets/app_loading_indicator.dart';
import 'course_providers.dart';

class CourseDetailsScreen extends ConsumerWidget {
  const CourseDetailsScreen({required this.courseId, super.key});
  final String courseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final course = ref.watch(courseDetailsProvider(courseId));
    return Scaffold(
      appBar: AppBar(title: const Text('Course details')),
      body: course.when(
        loading: () => const AppLoadingIndicator(),
        error: (error, _) => AppErrorView(
          onRetry: () => ref.invalidate(courseDetailsProvider(courseId)),
        ),
        data: (value) => _CourseBody(course: value),
      ),
    );
  }
}

class _CourseBody extends StatelessWidget {
  const _CourseBody({required this.course});
  final Map<String, dynamic> course;

  @override
  Widget build(BuildContext context) {
    final modules = (course['modules'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>();
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          course['title'] as String? ?? 'Course',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          '${course['learner_level'] ?? 'A1'}  •  ${course['estimated_total_minutes'] ?? 0} minutes',
        ),
        const SizedBox(height: 12),
        Text(course['full_description'] as String? ?? ''),
        const SizedBox(height: 20),
        for (final module in modules) _ModuleCard(module: module),
      ],
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({required this.module});
  final Map<String, dynamic> module;

  @override
  Widget build(BuildContext context) {
    final lessons = (module['lessons'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>();
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: ExpansionTile(
        title: Text(module['title'] as String? ?? 'Module'),
        subtitle: Text(module['description'] as String? ?? ''),
        children: [
          for (final lesson in lessons)
            ListTile(
              leading: Icon(
                lesson['completed'] == true
                    ? Icons.check_circle
                    : lesson['unlocked'] == true
                    ? Icons.play_circle_outline
                    : Icons.lock_outline,
              ),
              title: Text(lesson['title'] as String? ?? 'Lesson'),
              subtitle: Text('${lesson['estimated_minutes'] ?? 0} minutes'),
              trailing: lesson['completed'] == true
                  ? Text('${lesson['score'] ?? 0}%')
                  : null,
              onTap: lesson['unlocked'] == true
                  ? () => context.push('/lessons/${lesson['id']}')
                  : null,
            ),
        ],
      ),
    );
  }
}
