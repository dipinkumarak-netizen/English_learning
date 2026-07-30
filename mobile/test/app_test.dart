import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nilaspeak_mobile/app/app.dart';

void main() {
  testWidgets('renders the NilaSpeak welcome flow', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: NilaSpeakApp()));
    await tester.pumpAndSettle();
    expect(find.text('തുടരുക'), findsOneWidget);
  });
}
