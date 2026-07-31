import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nilaspeak_mobile/app/app.dart';
import 'package:nilaspeak_mobile/features/onboarding/presentation/onboarding_screen.dart';

void main() {
  testWidgets('starts with an English-only application locale', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: NilaSpeakApp()));
    await tester.pumpAndSettle();
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.locale, const Locale('en'));
    expect(app.supportedLocales, [const Locale('en')]);
  });

  test('normalizes drafts from the removed application-language step', () {
    expect(
      normalizeOnboardingStep(savedStep: 6, hasLegacyApplicationStep: true),
      5,
    );
    expect(
      normalizeOnboardingStep(savedStep: 5, hasLegacyApplicationStep: false),
      5,
    );
  });
}
