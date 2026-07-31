import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nilaspeak_mobile/features/courses/presentation/lesson_player_screen.dart';

void main() {
  const types = [
    'single_choice',
    'multiple_choice',
    'fill_blank',
    'reorder_words',
    'match_pairs',
    'natural_sentence',
    'correct_mistake',
    'translation',
    'reading_comprehension',
    'true_false',
  ];

  for (final type in types) {
    testWidgets('renders $type exercise', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseRenderer(
              exercise: {
                'id': 'exercise-$type',
                'exercise_type': type,
                'prompt_en': 'Try this exercise',
                'options': type == 'fill_blank'
                    ? <String>[]
                    : <String>['one', 'two'],
              },
              answer: null,
              submitted: false,
              feedback: null,
              onAnswer: (_) {},
            ),
          ),
        ),
      );
      expect(find.byType(ExerciseRenderer), findsOneWidget);
      if (type == 'fill_blank' ||
          type == 'correct_mistake' ||
          type == 'translation') {
        expect(find.byType(TextField), findsOneWidget);
      } else {
        expect(find.textContaining('one'), findsWidgets);
      }
    });
  }
}
