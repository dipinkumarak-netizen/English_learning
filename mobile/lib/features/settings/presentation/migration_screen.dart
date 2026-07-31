import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../authentication/presentation/auth_controller.dart';

class MigrationScreen extends ConsumerStatefulWidget {
  const MigrationScreen({super.key});
  @override
  ConsumerState<MigrationScreen> createState() => _MigrationScreenState();
}

class _MigrationScreenState extends ConsumerState<MigrationScreen> {
  bool _busy = false;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Move local progress')),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Local progress found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          const Text(
            'Choose how to continue with your connected account. The merge keeps completed work and uses server validation.',
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _busy ? null : () => _submit('merge'),
              child: Text(_busy ? 'Working…' : 'Merge local progress'),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _busy ? null : () => _submit('account'),
              child: const Text('Use account progress'),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: _busy ? null : () => context.go('/home'),
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    ),
  );

  Future<void> _submit(String mode) async {
    setState(() => _busy = true);
    try {
      final profile = await ref.read(databaseProvider).localProfile();
      await ref
          .read(apiClientProvider)
          .post(
            '/api/v1/sync/local-import',
            accessToken: await ref.read(tokenStorageProvider).readAccessToken(),
            data: {
              'client_import_operation_id':
                  'local-${profile?.id ?? DateTime.now().microsecondsSinceEpoch}',
              'mode': mode,
              'profile': profile == null
                  ? {}
                  : {
                      'display_name': profile.displayName,
                      'native_language': profile.nativeLanguage,
                      'explanation_language': profile.explanationLanguage,
                      'confidence_level': profile.confidenceLevel,
                      'learning_goals': profile.learningGoals,
                      'difficult_areas': profile.difficultAreas,
                      'daily_study_minutes': profile.dailyStudyMinutes,
                      'onboarding_complete': profile.onboardingComplete,
                    },
              'progress': [],
            },
          );
      if (mounted) context.go('/home');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Migration failed. Local data was kept.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
