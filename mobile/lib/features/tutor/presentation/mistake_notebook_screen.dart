import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_error_view.dart';
import '../../../core/widgets/app_loading_indicator.dart';
import 'tutor_providers.dart';

class MistakeNotebookScreen extends ConsumerWidget {
  const MistakeNotebookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mistakes = ref.watch(tutorMistakesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Mistake notebook')),
      body: mistakes.when(
        loading: () => const AppLoadingIndicator(),
        error: (error, _) =>
            AppErrorView(onRetry: () => ref.invalidate(tutorMistakesProvider)),
        data: (value) {
          final items = (value['mistakes'] as List<dynamic>? ?? const [])
              .cast<Map<String, dynamic>>();
          if (items.isEmpty) {
            return const Center(
              child: Text('Your saved corrections will appear here.'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                child: ListTile(
                  title: Text(item['corrected_sentence'] as String? ?? ''),
                  subtitle: Text(
                    '${item['mistake_category'] ?? 'Practice'}  •  repeated ${item['repeat_count'] ?? 1} time(s)',
                  ),
                  trailing: item['mastered'] == true
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : IconButton(
                          tooltip: 'Mark mastered',
                          icon: const Icon(Icons.check),
                          onPressed: () async {
                            await ref
                                .read(tutorRepositoryProvider)
                                .updateMistake(item['id'] as String, {
                                  'mastered': true,
                                  'review_status': 'reviewed',
                                });
                            ref.invalidate(tutorMistakesProvider);
                          },
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
