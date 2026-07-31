import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../l10n/app_localizations.dart';
import '../../authentication/presentation/auth_controller.dart';

int normalizeOnboardingStep({
  required int savedStep,
  required bool hasLegacyApplicationStep,
}) =>
    (hasLegacyApplicationStep ? savedStep - 1 : savedStep).clamp(0, 5).toInt();

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const _draftKey = 'onboarding_draft';
  int _step = 0;
  String _nativeLanguage = 'ml';
  String _explanationLanguage = 'ml';
  String _confidence = 'basics';
  int _dailyMinutes = 10;
  final Set<String> _goals = {'beginner_english'};
  final Set<String> _areas = {'speaking'};
  bool _busy = false;

  final _goalOptions = const [
    'daily_spoken_english',
    'beginner_english',
    'grammar',
    'vocabulary',
    'pronunciation',
    'job_interview',
    'workplace',
    'travel',
    'writing',
    'fluency',
  ];
  final _areaOptions = const [
    'speaking',
    'listening',
    'grammar',
    'vocabulary',
    'pronunciation',
    'reading',
    'writing',
    'confidence',
  ];
  final _confidenceOptions = const [
    'basics',
    'words',
    'sentences',
    'short_conversations',
    'frequent_mistakes',
    'comfortable',
  ];

  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.onboardingTitle)),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: LinearProgressIndicator(value: (_step + 1) / 6),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _content(l10n),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  if (_step > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _busy ? null : () => setState(() => _step--),
                        child: Text(l10n.back),
                      ),
                    ),
                  if (_step > 0) const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _busy ? null : () => _next(l10n),
                      child: _busy
                          ? const CircularProgressIndicator()
                          : Text(_step == 5 ? l10n.finish : l10n.next),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _content(AppLocalizations l10n) {
    switch (_step) {
      case 0:
        return _choiceSection(
          l10n.nativeLanguage,
          ['ml', 'en'],
          _nativeLanguage,
          (value) => setState(() {
            _nativeLanguage = value;
            _explanationLanguage = value;
          }),
        );
      case 1:
        return _choiceSection(
          l10n.confidence,
          _confidenceOptions,
          _confidence,
          (value) => setState(() => _confidence = value),
        );
      case 2:
        return _multiChoiceSection(l10n.goals, _goalOptions, _goals);
      case 3:
        return _multiChoiceSection(l10n.difficultAreas, _areaOptions, _areas);
      case 4:
        return _choiceSection(
          l10n.dailyStudyTime,
          ['5', '10', '15', '20', '30'],
          '$_dailyMinutes',
          (value) => setState(() => _dailyMinutes = int.parse(value)),
        );
      default:
        return _choiceSection(
          l10n.explanationLanguage,
          ['ml', 'en'],
          _explanationLanguage,
          (value) => setState(() => _explanationLanguage = value),
        );
    }
  }

  Widget _choiceSection(
    String title,
    List<String> options,
    String selected,
    ValueChanged<String> onSelected,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 20),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: options
            .map(
              (value) => ChoiceChip(
                label: Text(value.replaceAll('_', ' ')),
                selected: value == selected,
                onSelected: (_) => onSelected(value),
              ),
            )
            .toList(),
      ),
    ],
  );

  Widget _multiChoiceSection(
    String title,
    List<String> options,
    Set<String> selected,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 20),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: options
            .map(
              (value) => FilterChip(
                label: Text(value.replaceAll('_', ' ')),
                selected: selected.contains(value),
                onSelected: (checked) => setState(() {
                  if (checked) {
                    selected.add(value);
                  } else {
                    selected.remove(value);
                  }
                }),
              ),
            )
            .toList(),
      ),
    ],
  );

  Future<void> _next(AppLocalizations l10n) async {
    if ((_step == 2 && _goals.isEmpty) || (_step == 3 && _areas.isEmpty)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.selectOne)));
      return;
    }
    await _saveDraft();
    if (_step < 5) {
      setState(() => _step++);
      return;
    }
    setState(() => _busy = true);
    try {
      final token = await ref.read(tokenStorageProvider).readAccessToken();
      if (token == null) throw StateError('No session');
      final profile = {
        'native_language': _nativeLanguage,
        'explanation_language': _explanationLanguage,
        'confidence_level': _confidence,
        'daily_study_minutes': _dailyMinutes,
        'learning_goals': _goals.toList(),
        'difficult_areas': _areas.toList(),
      };
      await ref
          .read(apiClientProvider)
          .post(
            '/api/v1/onboarding/complete',
            data: {'profile': profile},
            accessToken: token,
          );
      await ref.read(authStateProvider.notifier).markOnboardingComplete();
      if (mounted) context.go('/placement');
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

  Future<void> _loadDraft() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove('application_language');
    final raw = preferences.getString(_draftKey);
    if (raw == null) return;
    final draft = jsonDecode(raw) as Map<String, dynamic>;
    if (!mounted) return;
    setState(() {
      final savedStep = draft['step'] as int? ?? 0;
      final hadLegacyApplicationStep = draft.containsKey(
        'application_language',
      );
      _step = normalizeOnboardingStep(
        savedStep: savedStep,
        hasLegacyApplicationStep: hadLegacyApplicationStep,
      );
      _nativeLanguage = draft['native_language'] as String? ?? _nativeLanguage;
      _explanationLanguage =
          draft['explanation_language'] as String? ?? _explanationLanguage;
      _confidence = draft['confidence'] as String? ?? _confidence;
      _dailyMinutes = draft['daily_minutes'] as int? ?? _dailyMinutes;
      _goals
        ..clear()
        ..addAll((draft['goals'] as List<dynamic>? ?? []).cast<String>());
      _areas
        ..clear()
        ..addAll((draft['areas'] as List<dynamic>? ?? []).cast<String>());
    });
  }

  Future<void> _saveDraft() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _draftKey,
      jsonEncode({
        'step': _step,
        'native_language': _nativeLanguage,
        'explanation_language': _explanationLanguage,
        'confidence': _confidence,
        'daily_minutes': _dailyMinutes,
        'goals': _goals.toList(),
        'areas': _areas.toList(),
      }),
    );
  }
}
