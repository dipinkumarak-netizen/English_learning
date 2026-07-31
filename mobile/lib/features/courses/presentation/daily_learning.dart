import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authentication/presentation/auth_controller.dart';
import 'course_providers.dart';

enum DailyDayStatus { locked, available, inProgress, completed, review }

class DailyLearningDay {
  const DailyLearningDay({
    required this.dayNumber,
    required this.lessonId,
    required this.title,
    required this.durationMinutes,
    required this.status,
    required this.score,
    this.currentStepId,
  });

  final int dayNumber;
  final String lessonId;
  final String title;
  final int durationMinutes;
  final DailyDayStatus status;
  final double score;
  final String? currentStepId;

  bool get isOpen => status != DailyDayStatus.locked;
  bool get isCompleted => status == DailyDayStatus.completed;
}

class DailyLearningPath {
  const DailyLearningPath({required this.courseTitle, required this.days});

  final String courseTitle;
  final List<DailyLearningDay> days;

  int get completedDays => days.where((day) => day.isCompleted).length;
  int get currentDay {
    final index = days.indexWhere((day) => !day.isCompleted && day.isOpen);
    return index == -1 ? days.length : index + 1;
  }

  DailyLearningDay? get continueDay =>
      days.where((day) => day.isOpen && !day.isCompleted).firstOrNull ??
      days.where((day) => day.isCompleted).lastOrNull;
  double get completionPercentage =>
      days.isEmpty ? 0 : completedDays / days.length * 100;
}

final dailyLearningPathProvider = FutureProvider.autoDispose<DailyLearningPath>(
  (ref) async {
    final database = ref.read(databaseProvider);
    final token = await ref.read(tokenStorageProvider).readAccessToken();
    final courses = await ref.read(courseRepositoryProvider).courses();
    final course =
        courses.firstOrNull ??
        <String, dynamic>{'title': 'Everyday English Foundations'};
    final modules = (course['modules'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>();
    final lessons = <Map<String, dynamic>>[
      for (final module in modules)
        ...((module['lessons'] as List<dynamic>? ?? const [])
            .cast<Map<String, dynamic>>()),
    ];
    final localProgress = await database
        .select(database.localLessonProgress)
        .get();
    final progressByLesson = {
      for (final item in localProgress) item.lessonId: item,
    };

    final sourceLessons = token == null || lessons.length < 12
        ? _offlineDays
        : lessons;
    final days = <DailyLearningDay>[];
    for (var index = 0; index < sourceLessons.length; index++) {
      final lesson = sourceLessons[index];
      final dayNumber = (lesson['day_number'] as num?)?.toInt() ?? index + 1;
      final id = lesson['id'] as String? ?? 'offline-day-$dayNumber';
      final local = progressByLesson[id];
      final completed = lesson['completed'] == true || local?.score == 100;
      final previousCompleted = index == 0 || days[index - 1].isCompleted;
      final unlocked = lesson['unlocked'] == true || previousCompleted;
      final status = completed
          ? DailyDayStatus.completed
          : !unlocked
          ? DailyDayStatus.locked
          : local != null
          ? DailyDayStatus.inProgress
          : DailyDayStatus.available;
      days.add(
        DailyLearningDay(
          dayNumber: dayNumber,
          lessonId: id,
          title: lesson['title'] as String? ?? 'Daily English practice',
          durationMinutes: (lesson['estimated_minutes'] as num?)?.toInt() ?? 20,
          status: status,
          score: (lesson['score'] as num?)?.toDouble() ?? local?.score ?? 0,
          currentStepId: local?.currentStepId,
        ),
      );
    }
    return DailyLearningPath(
      courseTitle: course['title'] as String? ?? 'Everyday English Foundations',
      days: days,
    );
  },
);

final _offlineDays = List<Map<String, dynamic>>.generate(
  12,
  (index) => {
    'id': 'offline-day-${index + 1}',
    'day_number': index + 1,
    'title': 'Everyday English Day ${index + 1}',
    'estimated_minutes': 20,
  },
);
