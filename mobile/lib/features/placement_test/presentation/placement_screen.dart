import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../authentication/presentation/auth_controller.dart';

class PlacementScreen extends ConsumerStatefulWidget {
  const PlacementScreen({super.key});

  @override
  ConsumerState<PlacementScreen> createState() => _PlacementScreenState();
}

class _PlacementScreenState extends ConsumerState<PlacementScreen> {
  List<Map<String, dynamic>> _questions = [];
  final Map<String, dynamic> _answers = {};
  Map<String, dynamic>? _result;
  String? _attemptId;
  bool _loading = true;
  bool _busy = false;
  bool _localMode = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_result != null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.estimatedLevel)),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _result!['estimated_level'] as String,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 12),
              Text('${_result!['percentage']}%'),
              const SizedBox(height: 24),
              Text(
                l10n.planSummary,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(_result!['recommended_track'] as String),
              const Spacer(),
              Text(l10n.assessmentDeferred),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.go('/learning-plan'),
                  child: Text(l10n.next),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(l10n.placementTitle)),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(l10n.placementDescription),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _questions.length,
                itemBuilder: (context, index) =>
                    _questionCard(_questions[index], index),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _busy ? null : () => _submit(l10n),
                  child: _busy
                      ? const CircularProgressIndicator()
                      : Text(l10n.submit),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _questionCard(Map<String, dynamic> question, int index) {
    final id = question['id'] as String;
    final options = (question['options'] as List<dynamic>?)?.cast<String>();
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${index + 1}. ${question['prompt']}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            if (options != null)
              RadioGroup<String>(
                groupValue: _answers[id] as String?,
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _answers[id] = value);
                  }
                },
                child: Column(
                  children: options
                      .map(
                        (option) => RadioListTile<String>(
                          contentPadding: EdgeInsets.zero,
                          title: Text(option),
                          value: option,
                        ),
                      )
                      .toList(),
                ),
              ),
            if (options == null)
              TextFormField(
                initialValue: _answers[id] as String?,
                onChanged: (value) => _answers[id] = value,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _load() async {
    try {
      final token = await ref.read(tokenStorageProvider).readAccessToken();
      if (token == null) {
        _localMode = true;
        _questions = const [
          {
            'id': 'local-1',
            'prompt': 'Choose the correct sentence.',
            'options': ['I am happy.', 'I happy am.'],
          },
          {
            'id': 'local-2',
            'prompt': 'Choose the correct word: She ___ to school.',
            'options': ['go', 'goes'],
          },
          {
            'id': 'local-3',
            'prompt': 'Choose the natural sentence.',
            'options': ['I like tea.', 'I tea like.'],
          },
        ];
        if (mounted) setState(() => _loading = false);
        return;
      }
      final client = ref.read(apiClientProvider);
      final assessment = await client.get(
        '/api/v1/placement/assessment',
        accessToken: token,
      );
      final attempt = await client.post(
        '/api/v1/placement/attempts',
        accessToken: token,
      );
      if (!mounted) return;
      setState(() {
        _questions = (assessment['questions'] as List<dynamic>)
            .cast<Map<String, dynamic>>();
        _attemptId = attempt['id'] as String;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _submit(AppLocalizations l10n) async {
    if (_answers.length < _questions.length) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.selectOne)));
      return;
    }
    setState(() => _busy = true);
    try {
      final token = await ref.read(tokenStorageProvider).readAccessToken();
      if (_localMode || token == null) {
        final correct = {
          'local-1': 'I am happy.',
          'local-2': 'goes',
          'local-3': 'I like tea.',
        };
        final raw = _answers.entries
            .where((entry) => correct[entry.key] == entry.value)
            .length;
        final percentage = raw / _questions.length * 100;
        final level = percentage >= 80
            ? 'A2'
            : percentage >= 50
            ? 'A1'
            : 'starter';
        if (mounted) {
          setState(
            () => _result = {
              'estimated_level': level,
              'percentage': percentage.round(),
              'recommended_track': 'Everyday English foundations',
            },
          );
        }
        return;
      }
      if (_attemptId == null) throw StateError('No session');
      final client = ref.read(apiClientProvider);
      for (final entry in _answers.entries) {
        await client.put(
          '/api/v1/placement/attempts/$_attemptId/answers/${entry.key}',
          data: {'answer': entry.value},
          accessToken: token,
        );
      }
      final result = await client.post(
        '/api/v1/placement/attempts/$_attemptId/submit',
        accessToken: token,
      );
      if (mounted) setState(() => _result = result);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.genericError)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
