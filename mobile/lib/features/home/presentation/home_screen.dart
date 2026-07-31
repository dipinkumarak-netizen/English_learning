import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../authentication/presentation/auth_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
        actions: [
          IconButton(
            tooltip: l10n.profile,
            onPressed: () => context.go('/profile'),
            icon: const Icon(Icons.person_outline),
          ),
          IconButton(
            tooltip: 'Settings',
            onPressed: () => context.go('/settings'),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            l10n.homeHeading,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: const Icon(Icons.menu_book_outlined),
              title: const Text('Course library'),
              subtitle: const Text('Continue with practical English lessons.'),
              onTap: () => context.go('/courses'),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.forum_outlined),
              title: const Text('AI English tutor'),
              subtitle: const Text(
                'Practise with secure text-only learning support.',
              ),
              onTap: () {
                if (ref.read(authStateProvider).isAuthenticated) {
                  context.go('/tutor');
                } else {
                  _showTutorSignIn(context);
                }
              },
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.insights_outlined),
              title: const Text('Progress summary'),
              subtitle: const Text(
                'See your completed lessons and course progress.',
              ),
              onTap: () => context.go('/progress'),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.auto_graph),
              title: Text(l10n.planSummary),
              subtitle: Text(l10n.noPlan),
              onTap: () => context.go('/learning-plan'),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.fact_check_outlined),
              title: Text(l10n.placementInvite),
              subtitle: Text(l10n.placementDescription),
              onTap: () => context.go('/placement'),
            ),
          ),
          if (!ref.watch(authStateProvider).isAuthenticated) ...[
            const SizedBox(height: 24),
            Card(
              child: ListTile(
                leading: const Icon(Icons.cloud_upload_outlined),
                title: const Text('Back up your progress'),
                subtitle: const Text(
                  'Sign in to sync lessons and use the AI Tutor.',
                ),
                onTap: () => context.go('/settings'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showTutorSignIn(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign in to use the AI Tutor'),
        content: const Text(
          'The AI Tutor uses the secure NilaSpeak backend to generate responses and save tutor history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Not now'),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/signup');
            },
            child: const Text('Create account'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/signin');
            },
            child: const Text('Sign in'),
          ),
        ],
      ),
    );
  }
}
