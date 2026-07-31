import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_error_view.dart';
import '../../../core/widgets/app_loading_indicator.dart';
import 'course_providers.dart';

class ProgressSummaryScreen extends ConsumerWidget {
  const ProgressSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(progressSummaryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Progress summary')),
      body: summary.when(
        loading: () => const AppLoadingIndicator(),
        error: (error, _) => AppErrorView(
          onRetry: () => ref.invalidate(progressSummaryProvider),
        ),
        data: (value) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'Your learning progress',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      value:
                          ((value['completion_percentage'] as num?)
                                  ?.toDouble() ??
                              0) /
                          100,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${((value['completion_percentage'] as num?)?.round() ?? 0)}% complete',
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: const Text('Lessons completed'),
              trailing: Text('${value['lessons_completed'] ?? 0}'),
            ),
            ListTile(
              title: const Text('Lessons available'),
              trailing: Text('${value['lessons_available'] ?? 0}'),
            ),
          ],
        ),
      ),
    );
  }
}
