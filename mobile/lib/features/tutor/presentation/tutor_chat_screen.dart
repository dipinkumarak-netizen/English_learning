import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_error_view.dart';
import '../../../core/widgets/app_loading_indicator.dart';
import 'tutor_providers.dart';

class TutorChatScreen extends ConsumerStatefulWidget {
  const TutorChatScreen({required this.conversationId, super.key});
  final String conversationId;

  @override
  ConsumerState<TutorChatScreen> createState() => _TutorChatScreenState();
}

class _TutorChatScreenState extends ConsumerState<TutorChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _sending = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(tutorMessagesProvider(widget.conversationId));
    final router = GoRouter.maybeOf(context);
    final canPop = router != null && context.canPop();
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && router != null) context.go('/tutor');
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Tutor conversation')),
        body: Column(
          children: [
            Expanded(
              child: messages.when(
                loading: () => const AppLoadingIndicator(),
                error: (error, _) => AppErrorView(
                  onRetry: () => ref.invalidate(
                    tutorMessagesProvider(widget.conversationId),
                  ),
                ),
                data: (items) => ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) =>
                      _MessageBubble(message: items[index]),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        maxLines: 4,
                        minLines: 1,
                        enabled: !_sending,
                        decoration: const InputDecoration(
                          hintText: 'Write an English-learning message',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      tooltip: 'Send message',
                      onPressed: _sending ? null : _send,
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || text.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Write a little more before sending.')),
      );
      return;
    }
    setState(() => _sending = true);
    try {
      await ref
          .read(tutorRepositoryProvider)
          .send(
            widget.conversationId,
            text,
            'mobile-tutor-${DateTime.now().microsecondsSinceEpoch}',
          );
      _controller.clear();
      ref.invalidate(tutorMessagesProvider(widget.conversationId));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'The tutor could not reply. Check configuration or try again.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});
  final Map<String, dynamic> message;

  @override
  Widget build(BuildContext context) {
    final learner = message['role'] == 'learner';
    final structured = message['structured_response'] as Map<String, dynamic>?;
    return Align(
      alignment: learner ? Alignment.centerRight : Alignment.centerLeft,
      child: Card(
        color: learner ? Theme.of(context).colorScheme.primaryContainer : null,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 340),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  (message['original_learner_text'] ??
                          message['tutor_reply'] ??
                          '')
                      as String,
                ),
                if (structured?['corrected_sentence'] != null) ...[
                  const Divider(),
                  const Text(
                    'Correction',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SelectableText(structured!['corrected_sentence'] as String),
                  if (structured['explanation_en'] != null)
                    Text(structured['explanation_en'] as String),
                  if (structured['explanation_ml'] != null)
                    Text(structured['explanation_ml'] as String),
                ],
                if (structured?['vocabulary_items'] is List &&
                    (structured!['vocabulary_items'] as List).isNotEmpty)
                  Text(
                    'Words: ${(structured['vocabulary_items'] as List).join(', ')}',
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
