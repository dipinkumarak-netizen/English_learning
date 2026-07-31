import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_error_view.dart';
import '../../../core/widgets/app_loading_indicator.dart';
import 'course_providers.dart';

class LessonPlayerScreen extends ConsumerStatefulWidget {
  const LessonPlayerScreen({required this.lessonId, super.key});
  final String lessonId;

  @override
  ConsumerState<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends ConsumerState<LessonPlayerScreen> {
  int _stepIndex = 0;
  bool _submitted = false;
  bool _busy = false;
  Object? _answer;
  Map<String, dynamic>? _feedback;

  String _operationId() => 'mobile-${DateTime.now().microsecondsSinceEpoch}';

  @override
  Widget build(BuildContext context) {
    final lesson = ref.watch(lessonDetailsProvider(widget.lessonId));
    return Scaffold(
      appBar: AppBar(title: const Text('Lesson')),
      body: lesson.when(
        loading: () => const AppLoadingIndicator(),
        error: (error, _) => AppErrorView(
          onRetry: () => ref.invalidate(lessonDetailsProvider(widget.lessonId)),
        ),
        data: (value) => _content(context, value),
      ),
    );
  }

  Widget _content(BuildContext context, Map<String, dynamic> lesson) {
    final steps = (lesson['steps'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>();
    if (steps.isEmpty) {
      return const Center(child: Text('This lesson has no steps yet.'));
    }
    final safeIndex = _stepIndex.clamp(0, steps.length - 1);
    final step = steps[safeIndex];
    final progress = (safeIndex + 1) / steps.length;
    return Column(
      children: [
        LinearProgressIndicator(value: progress),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                lesson['title'] as String? ?? 'Lesson',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              Text(
                step['title'] as String? ?? 'Step',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(step['content_en'] as String? ?? ''),
              if ((step['explanation_ml'] as String?)?.isNotEmpty == true) ...[
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(step['explanation_ml'] as String),
                  ),
                ),
              ],
              if (step['step_type'] == 'exercise' &&
                  step['exercise'] is Map<String, dynamic>) ...[
                const SizedBox(height: 24),
                _ExerciseCard(
                  exercise: step['exercise'] as Map<String, dynamic>,
                  answer: _answer,
                  submitted: _submitted,
                  feedback: _feedback,
                  onAnswer: (answer) => setState(() => _answer = answer),
                ),
              ],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              if (safeIndex > 0)
                OutlinedButton(
                  onPressed: _busy ? null : () => setState(() => _stepIndex--),
                  child: const Text('Back'),
                ),
              const Spacer(),
              FilledButton(
                onPressed: _busy
                    ? null
                    : () => _next(context, lesson, step, steps.length),
                child: Text(
                  safeIndex == steps.length - 1 ? 'Complete lesson' : 'Next',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _next(
    BuildContext context,
    Map<String, dynamic> lesson,
    Map<String, dynamic> step,
    int totalSteps,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final exercise = step['exercise'] as Map<String, dynamic>?;
    if (exercise != null && !_submitted) {
      if (_answer == null) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Choose an answer first.')),
        );
        return;
      }
      setState(() => _busy = true);
      try {
        final feedback = await ref
            .read(courseRepositoryProvider)
            .submitExercise(exercise['id'] as String, _answer!, _operationId());
        setState(() {
          _feedback = feedback;
          _submitted = true;
        });
      } catch (_) {
        if (mounted) {
          messenger.showSnackBar(
            const SnackBar(content: Text('Could not submit. Try again.')),
          );
        }
      } finally {
        if (mounted) setState(() => _busy = false);
      }
      return;
    }
    setState(() => _busy = true);
    try {
      await ref
          .read(courseRepositoryProvider)
          .completeStep(widget.lessonId, step['id'] as String, _operationId());
      if (_stepIndex < totalSteps - 1) {
        setState(() {
          _stepIndex++;
          _answer = null;
          _feedback = null;
          _submitted = false;
        });
      } else {
        final result = await ref
            .read(courseRepositoryProvider)
            .completeLesson(widget.lessonId);
        if (mounted) await _showCompletion(result);
      }
    } catch (_) {
      if (mounted) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Complete the required steps first.')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _showCompletion(Map<String, dynamic> result) async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Lesson complete'),
        content: Text(
          'Score: ${(result['score'] as num?)?.round() ?? 0}%\nKeep practising a little every day.',
        ),
        actions: [
          FilledButton(
            onPressed: () => this.context
              ..pop()
              ..pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

class _ExerciseCard extends StatefulWidget {
  const _ExerciseCard({
    required this.exercise,
    required this.answer,
    required this.submitted,
    required this.feedback,
    required this.onAnswer,
  });
  final Map<String, dynamic> exercise;
  final Object? answer;
  final bool submitted;
  final Map<String, dynamic>? feedback;
  final ValueChanged<Object> onAnswer;

  @override
  State<_ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<_ExerciseCard> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.exercise['exercise_type'] as String? ?? 'single_choice';
    final options = (widget.exercise['options'] as List<dynamic>? ?? const [])
        .cast<String>();
    final choiceType =
        type == 'single_choice' ||
        type == 'natural_sentence' ||
        type == 'reading_comprehension' ||
        type == 'true_false';
    if (choiceType) {
      return _choice(options);
    }
    if (type == 'multiple_choice' || type == 'match_pairs') {
      return _multiChoice(options);
    }
    if (type == 'reorder_words') return _reorder(options);
    return Column(
      children: [
        TextField(
          controller: _textController,
          enabled: !widget.submitted,
          decoration: const InputDecoration(
            labelText: 'Your answer',
            border: OutlineInputBorder(),
          ),
          onChanged: widget.onAnswer,
        ),
        if (widget.submitted) _feedbackView(),
      ],
    );
  }

  Widget _choice(List<String> options) => Column(
    children: options
        .map(
          (option) => ListTile(
            leading: Icon(
              widget.answer == option
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
            ),
            title: Text(option),
            enabled: !widget.submitted,
            onTap: widget.submitted ? null : () => widget.onAnswer(option),
          ),
        )
        .toList(),
  );

  Widget _multiChoice(List<String> options) {
    final selected = ((widget.answer as List<dynamic>?) ?? const [])
        .cast<String>();
    return Column(
      children: options
          .map(
            (option) => CheckboxListTile(
              title: Text(option),
              value: selected.contains(option),
              onChanged: widget.submitted
                  ? null
                  : (checked) {
                      final next = [...selected];
                      checked == true ? next.add(option) : next.remove(option);
                      widget.onAnswer(next);
                    },
            ),
          )
          .toList(),
    );
  }

  Widget _reorder(List<String> options) => Wrap(
    spacing: 8,
    children: options
        .map(
          (word) => ActionChip(
            label: Text(word),
            onPressed: widget.submitted
                ? null
                : () {
                    final next = [
                      ...((widget.answer as List<dynamic>?) ?? const [])
                          .cast<String>(),
                      word,
                    ];
                    widget.onAnswer(next);
                  },
          ),
        )
        .toList(),
  );

  Widget _feedbackView() => Padding(
    padding: const EdgeInsets.only(top: 16),
    child: Text(
      widget.feedback?['is_correct'] == true
          ? 'Correct. ${widget.feedback?['explanation_en'] ?? ''}'
          : 'Not quite. Try again.',
      style: TextStyle(
        color: widget.feedback?['is_correct'] == true
            ? Colors.green
            : Colors.red,
      ),
    ),
  );
}
