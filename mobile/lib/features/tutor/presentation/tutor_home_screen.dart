import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_error_view.dart';
import '../../../core/widgets/app_loading_indicator.dart';
import 'tutor_providers.dart';
import '../../authentication/presentation/auth_controller.dart';
import '../../voice/presentation/voice_providers.dart';

class TutorHomeScreen extends ConsumerStatefulWidget {
  const TutorHomeScreen({super.key});

  @override
  ConsumerState<TutorHomeScreen> createState() => _TutorHomeScreenState();
}

class _TutorHomeScreenState extends ConsumerState<TutorHomeScreen> {
  String _mode = 'beginner_conversation';
  bool _creating = false;

  @override
  Widget build(BuildContext context) {
    if (!ref.watch(authStateProvider).isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('AI English tutor')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sign in to use the AI Tutor',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'The AI Tutor uses the secure NilaSpeak backend to generate responses and save your tutor history.',
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => context.push('/signin'),
                child: const Text('Sign in'),
              ),
              OutlinedButton(
                onPressed: () => context.push('/signup'),
                child: const Text('Create account'),
              ),
              TextButton(
                onPressed: () => context.go('/dashboard'),
                child: const Text('Not now'),
              ),
            ],
          ),
        ),
      );
    }
    final conversations = ref.watch(tutorConversationsProvider);
    final usage = ref.watch(tutorUsageProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI English tutor'),
        actions: [
          IconButton(
            tooltip: 'Mistake notebook',
            onPressed: () => context.go('/tutor/mistakes'),
            icon: const Icon(Icons.auto_stories_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Practise with text only. Malayalam appears only as learning support.',
          ),
          const SizedBox(height: 16),
          usage.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, _) => const Text('Tutor usage status unavailable.'),
            data: (value) => Card(
              child: ListTile(
                leading: const Icon(Icons.speed_outlined),
                title: const Text('Daily practice safety limit'),
                subtitle: Text(
                  '${value['requests_today'] ?? 0} of ${value['daily_request_limit'] ?? 0} requests used',
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Start a new practice',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: _mode,
                    items: const [
                      DropdownMenuItem(
                        value: 'beginner_conversation',
                        child: Text('Beginner conversation'),
                      ),
                      DropdownMenuItem(
                        value: 'grammar_correction',
                        child: Text('Grammar correction'),
                      ),
                      DropdownMenuItem(
                        value: 'sentence_improvement',
                        child: Text('Sentence improvement'),
                      ),
                      DropdownMenuItem(
                        value: 'ml_to_english',
                        child: Text('Malayalam to English'),
                      ),
                      DropdownMenuItem(
                        value: 'writing_correction',
                        child: Text('Writing correction'),
                      ),
                      DropdownMenuItem(
                        value: 'role_play',
                        child: Text('Role-play foundation'),
                      ),
                    ],
                    onChanged: (value) => setState(() => _mode = value!),
                  ),
                  FilledButton.icon(
                    onPressed: _creating ? null : _createConversation,
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: Text(_creating ? 'Starting…' : 'Start practice'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _creating ? null : _createVoiceConversation,
                    icon: const Icon(Icons.mic_none),
                    label: const Text('Start voice conversation'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Recent conversations',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          conversations.when(
            loading: () => const AppLoadingIndicator(),
            error: (error, _) => AppErrorView(
              onRetry: () => ref.invalidate(tutorConversationsProvider),
            ),
            data: (items) => items.isEmpty
                ? const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text('No conversations yet.'),
                  )
                : Column(
                    children: items
                        .map(
                          (item) => ListTile(
                            leading: const Icon(Icons.forum_outlined),
                            title: Text(
                              item['title'] as String? ?? 'English practice',
                            ),
                            subtitle: Text(
                              item['mode'] as String? ?? 'Practice',
                            ),
                            onTap: () =>
                                context.push('/tutor/chat/${item['id']}'),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _createConversation() async {
    setState(() => _creating = true);
    try {
      final conversation = await ref
          .read(tutorRepositoryProvider)
          .createConversation(_mode, 'important');
      if (mounted) {
        context.push('/tutor/chat/${conversation['id']}');
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The tutor is not configured or unavailable.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }

  Future<void> _createVoiceConversation() async {
    setState(() => _creating = true);
    try {
      final conversation = await ref
          .read(tutorRepositoryProvider)
          .createConversation(_mode, 'important');
      final session = await ref
          .read(voiceRepositoryProvider)
          .createSession(conversation['id'] as String);
      if (mounted) context.push('/tutor/voice/${session['id']}');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Voice conversation needs a connected account and backend.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }
}
