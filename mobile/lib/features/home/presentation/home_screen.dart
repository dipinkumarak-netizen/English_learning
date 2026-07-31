import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../courses/presentation/daily_learning.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            tooltip: l10n.profile,
            onPressed: () => context.push('/profile'),
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Text(
            l10n.homeHeading,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 6),
          const Text('Your daily English learning path'),
          const SizedBox(height: 18),
          ref
              .watch(dailyLearningPathProvider)
              .when(
                loading: () => const LinearProgressIndicator(),
                error: (_, _) => const Card(
                  child: ListTile(
                    title: Text('Start Day 1'),
                    subtitle: Text('Begin your English practice.'),
                  ),
                ),
                data: (path) => _ContinueDayCard(path: path),
              ),
          const SizedBox(height: 14),
          Card(
            child: ListTile(
              leading: const Icon(Icons.menu_book_outlined),
              title: const Text('Your Learning Path'),
              subtitle: const Text(
                'Follow the daily sequence from Day 1 to Day 12.',
              ),
              onTap: () => context.go('/learn'),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const Icon(Icons.forum_outlined),
              title: const Text('AI English tutor'),
              subtitle: const Text(
                'Practise with secure text-only learning support.',
              ),
              onTap: () => context.go('/tutor'),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const Icon(Icons.insights_outlined),
              title: const Text('Progress summary'),
              subtitle: const Text(
                'See completed days, lessons, and weekly activity.',
              ),
              onTap: () => context.go('/progress'),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const Icon(Icons.auto_graph),
              title: Text(l10n.planSummary),
              subtitle: Text(l10n.noPlan),
              onTap: () => context.push('/learning-plan'),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const Icon(Icons.auto_stories_outlined),
              title: const Text('Mistake Notebook'),
              subtitle: const Text('Review corrections and useful patterns.'),
              onTap: () => context.push('/tutor/mistakes'),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const Icon(Icons.fact_check_outlined),
              title: Text(l10n.placementInvite),
              subtitle: Text(l10n.placementDescription),
              onTap: () => context.push('/placement'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContinueDayCard extends StatelessWidget {
  const _ContinueDayCard({required this.path});
  final DailyLearningPath path;

  @override
  Widget build(BuildContext context) {
    final day = path.continueDay;
    if (day == null || path.days.every((item) => item.isCompleted)) {
      return Card(
        child: ListTile(
          leading: const Icon(Icons.celebration_outlined),
          title: const Text('Course Complete'),
          subtitle: const Text(
            'Review any completed day from your learning path.',
          ),
        ),
      );
    }
    final label = day.status == DailyDayStatus.inProgress
        ? 'Continue Day ${day.dayNumber}'
        : 'Start Day ${day.dayNumber}';
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(day.title),
            Text(
              '${day.durationMinutes} minutes · ${path.completionPercentage.round()}% course complete',
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => context.push(
                  '/lessons/${day.lessonId}?day=${day.dayNumber}',
                ),
                child: Text(label),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
