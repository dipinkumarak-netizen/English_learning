import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../authentication/presentation/auth_controller.dart';
import 'backend_connection_card.dart';
import 'provider_settings_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);
    final connected = auth.isAuthenticated;
    final user = auth.user;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Account',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: connected
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?['display_name']?.toString() ??
                              'Connected account',
                        ),
                        Text(user?['email']?.toString() ?? ''),
                        const SizedBox(height: 12),
                        const Text('Sync status: Sign in connected'),
                        const SizedBox(height: 8),
                        FilledButton(
                          onPressed: () => _sync(context, ref),
                          child: const Text('Sync now'),
                        ),
                        TextButton(
                          onPressed: () => _logout(context, ref),
                          child: const Text('Log out'),
                        ),
                        TextButton(
                          onPressed: () => _deleteAccount(context, ref),
                          child: const Text('Delete account'),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Local profile',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Your learning progress is stored on this device.',
                        ),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: () => context.push('/signin'),
                          child: const Text('Sign in'),
                        ),
                        OutlinedButton(
                          onPressed: () => context.push('/signup'),
                          child: const Text('Create account'),
                        ),
                        const Text(
                          'Sign in to back up and sync progress and use server-based features.',
                        ),
                      ],
                    ),
            ),
          ),
          if (connected) ...[
            const SizedBox(height: 24),
            const ProviderSettingsCard(),
          ],
          const SizedBox(height: 24),
          const BackendConnectionCard(),
          const SizedBox(height: 24),
          const Text(
            'Learning preferences',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profile'),
            onTap: () => context.push('/profile'),
          ),
          ListTile(
            leading: const Icon(Icons.fact_check_outlined),
            title: const Text('Retake placement test'),
            onTap: () => context.push('/placement'),
          ),
          ListTile(
            leading: const Icon(Icons.auto_graph),
            title: const Text('Recalculate learning plan'),
            onTap: () => context.push('/learning-plan'),
          ),
          const SizedBox(height: 16),
          const Text(
            'Data',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const ListTile(
            title: Text('Offline content'),
            subtitle: Text(
              'Course content and local progress remain available offline.',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Reset local learning data'),
            onTap: () => _reset(context, ref),
          ),
          const SizedBox(height: 16),
          const Text(
            'About',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const ListTile(
            title: Text('NilaSpeak'),
            subtitle: Text(
              'Personal-use English learning application. Backend connection is optional.',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sync(BuildContext context, WidgetRef ref) async {
    try {
      await ref
          .read(apiClientProvider)
          .post(
            '/api/v1/progress/sync',
            accessToken: await ref.read(tokenStorageProvider).readAccessToken(),
            data: {'operations': []},
          );
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Sync complete.')));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Sync failed.')));
      }
    }
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final ok =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Log out?'),
            content: const Text(
              'Your local learning data will remain on this device. Server-only tutor history may not be available after logout.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Log out'),
              ),
            ],
          ),
        ) ??
        false;
    if (!ok) return;
    await ref.read(authStateProvider.notifier).signOut();
    if (context.mounted) context.go('/home');
  }

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    final ok =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete account?'),
            content: const Text(
              'This deletes the backend account. Local profile and course progress remain on this device unless you reset them separately.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete account'),
              ),
            ],
          ),
        ) ??
        false;
    if (!ok) return;
    try {
      await ref.read(authRepositoryProvider).deleteAccount();
      await ref.read(authStateProvider.notifier).signOut();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Account deleted. Local data remains on this device.',
            ),
          ),
        );
        context.go('/home');
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deletion failed.')),
        );
      }
    }
  }

  Future<void> _reset(BuildContext context, WidgetRef ref) async {
    final ok =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Reset local learning data?'),
            content: const Text(
              'This removes local profile, progress, pending sync, and tutor cache. It does not delete your backend account.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Reset'),
              ),
            ],
          ),
        ) ??
        false;
    if (ok) await ref.read(authStateProvider.notifier).resetLocalData();
  }
}
