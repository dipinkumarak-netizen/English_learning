import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_error_view.dart';
import '../../../core/widgets/app_loading_indicator.dart';
import 'daily_learning.dart';

class ProgressSummaryScreen extends ConsumerWidget {
  const ProgressSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = ref.watch(dailyLearningPathProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: path.when(
        loading: () => const AppLoadingIndicator(),
        error: (_, _) => AppErrorView(
          onRetry: () => ref.invalidate(dailyLearningPathProvider),
        ),
        data: (value) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Your learning progress',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 18),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      value: value.completionPercentage / 100,
                    ),
                    const SizedBox(height: 12),
                    Text('${value.completionPercentage.round()}% complete'),
                    const SizedBox(height: 8),
                    Text(
                      'Current day: ${value.currentDay} of ${value.days.length}',
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: const Text('Days completed'),
              trailing: Text('${value.completedDays}'),
            ),
            ListTile(
              title: const Text('Total days'),
              trailing: Text('${value.days.length}'),
            ),
            ListTile(
              title: const Text('Current learning day'),
              trailing: Text('Day ${value.currentDay}'),
            ),
            const ListTile(
              title: Text('Weekly learning minutes'),
              trailing: Text('Local tracking'),
            ),
            const ListTile(
              title: Text('Recent activity'),
              subtitle: Text(
                'Your latest day progress is shown in the learning path.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
