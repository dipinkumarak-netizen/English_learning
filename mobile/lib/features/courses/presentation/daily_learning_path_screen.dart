import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_error_view.dart';
import '../../../core/widgets/app_loading_indicator.dart';
import 'daily_learning.dart';

class DailyLearningPathScreen extends ConsumerWidget {
  const DailyLearningPathScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = ref.watch(dailyLearningPathProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Your Learning Path')),
      body: path.when(
        loading: () => const AppLoadingIndicator(),
        error: (_, _) => AppErrorView(
          onRetry: () => ref.invalidate(dailyLearningPathProvider),
        ),
        data: (value) => RefreshIndicator(
          onRefresh: () => ref.refresh(dailyLearningPathProvider.future),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Text(
                value.courseTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: value.completionPercentage / 100),
              const SizedBox(height: 8),
              Text(
                '${value.completedDays} of ${value.days.length} days complete',
              ),
              const SizedBox(height: 20),
              for (final day in value.days) _DayCard(day: day),
            ],
          ),
        ),
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({required this.day});
  final DailyLearningDay day;

  @override
  Widget build(BuildContext context) {
    final locked = day.status == DailyDayStatus.locked;
    final completed = day.status == DailyDayStatus.completed;
    final current =
        day.status == DailyDayStatus.available ||
        day.status == DailyDayStatus.inProgress;
    return Card(
      color: current ? Theme.of(context).colorScheme.primaryContainer : null,
      child: ListTile(
        enabled: !locked,
        leading: CircleAvatar(
          child: completed ? const Icon(Icons.check) : Text('${day.dayNumber}'),
        ),
        title: Text('Day ${day.dayNumber} — ${day.title}'),
        subtitle: Text(
          '${day.durationMinutes} minutes · ${_statusLabel(day.status)}${completed ? ' · ${day.score.round()}%' : ''}',
        ),
        trailing: Icon(
          locked
              ? Icons.lock_outline
              : completed
              ? Icons.replay
              : Icons.arrow_forward,
        ),
        onTap: locked
            ? null
            : () =>
                  context.push('/lessons/${day.lessonId}?day=${day.dayNumber}'),
      ),
    );
  }

  String _statusLabel(DailyDayStatus status) => switch (status) {
    DailyDayStatus.locked => 'Locked',
    DailyDayStatus.available => 'Available',
    DailyDayStatus.inProgress => 'In progress',
    DailyDayStatus.completed => 'Review',
    DailyDayStatus.review => 'Review',
  };
}
