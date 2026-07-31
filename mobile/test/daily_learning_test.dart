import 'package:flutter_test/flutter_test.dart';
import 'package:nilaspeak_mobile/features/courses/presentation/daily_learning.dart';

DailyLearningDay day(int number, DailyDayStatus status) => DailyLearningDay(
  dayNumber: number,
  lessonId: 'lesson-$number',
  title: 'Day $number',
  durationMinutes: 20,
  status: status,
  score: status == DailyDayStatus.completed ? 100 : 0,
);

void main() {
  test('daily path exposes completion, current day, and resume state', () {
    final path = DailyLearningPath(
      courseTitle: 'Foundations',
      days: [
        day(1, DailyDayStatus.completed),
        day(2, DailyDayStatus.inProgress),
        day(3, DailyDayStatus.locked),
      ],
    );

    expect(path.completedDays, 1);
    expect(path.currentDay, 2);
    expect(path.continueDay?.dayNumber, 2);
    expect(path.completionPercentage, closeTo(33.33, 0.01));
  });

  test('locked days are not open until the preceding day is complete', () {
    expect(day(2, DailyDayStatus.locked).isOpen, isFalse);
    expect(day(2, DailyDayStatus.available).isOpen, isTrue);
  });
}
