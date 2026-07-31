import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../authentication/presentation/auth_controller.dart';

class LearningPlanScreen extends ConsumerStatefulWidget {
  const LearningPlanScreen({super.key});

  @override
  ConsumerState<LearningPlanScreen> createState() => _LearningPlanScreenState();
}

class _LearningPlanScreenState extends ConsumerState<LearningPlanScreen> {
  Map<String, dynamic>? _plan;
  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.planSummary)),
      body: _plan == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  _plan!['estimated_level'] as String,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 8),
                Text(_plan!['recommended_track'] as String),
                const SizedBox(height: 24),
                Card(
                  child: ListTile(
                    title: Text(l10n.dailyStudyTime),
                    subtitle: Text(
                      '${_plan!['daily_study_minutes']} ${l10n.minutes}',
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(l10n.goals),
                    subtitle: Text(
                      (_plan!['priority_skills'] as List<dynamic>).join(', '),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text('Weekly target'),
                    subtitle: Text(
                      '${_plan!['weekly_target_minutes']} ${l10n.minutes}',
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _load() async {
    final token = await ref.read(tokenStorageProvider).readAccessToken();
    if (token == null) {
      final profile = await ref.read(databaseProvider).localProfile();
      if (mounted) {
        setState(
          () => _plan = {
            'estimated_level': 'A1',
            'recommended_track': 'Everyday English foundations',
            'daily_study_minutes': profile?.dailyStudyMinutes ?? 10,
            'priority_skills': ['grammar', 'vocabulary', 'speaking'],
            'weekly_target_minutes': (profile?.dailyStudyMinutes ?? 10) * 5,
          },
        );
      }
      return;
    }
    try {
      final plan = await ref
          .read(apiClientProvider)
          .get('/api/v1/learning-plan', accessToken: token);
      if (mounted) setState(() => _plan = plan);
    } catch (_) {
      if (mounted) setState(() => _plan = {});
    }
  }
}
