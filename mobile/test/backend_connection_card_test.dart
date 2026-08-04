import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nilaspeak_mobile/features/settings/data/capability_status_repository.dart';
import 'package:nilaspeak_mobile/features/settings/data/capability_status.dart';
import 'package:nilaspeak_mobile/features/settings/presentation/backend_connection_card.dart';
import 'package:nilaspeak_mobile/features/settings/presentation/capability_status_providers.dart';

class _WidgetTestSource implements CapabilityStatusSource {
  _WidgetTestSource({this.healthGate});
  final Completer<Map<String, dynamic>>? healthGate;

  @override
  Future<Map<String, dynamic>> health() =>
      healthGate?.future ?? Future.value({'status': 'ok'});

  @override
  Future<CapabilityStatus> fetch() async => CapabilityStatus.fromJson({
    'transport_state': 'secure_https',
    'provider_mutations_allowed': true,
    'ai': {},
    'stt': {},
    'tts': {},
  });
}

Widget _host(CapabilityStatusController controller) => ProviderScope(
  overrides: [capabilityStatusProvider.overrideWith((ref) => controller)],
  child: const MaterialApp(home: Scaffold(body: BackendConnectionCard())),
);

void main() {
  testWidgets('connection card persists Connected through reconstruction', (
    tester,
  ) async {
    final healthGate = Completer<Map<String, dynamic>>();
    final controller = CapabilityStatusController(
      _WidgetTestSource(healthGate: healthGate),
    );
    await tester.pumpWidget(_host(controller));
    expect(find.text('Status: Not tested'), findsOneWidget);

    final test = controller.testConnection();
    await tester.pump();
    expect(find.text('Status: Testing…'), findsOneWidget);
    healthGate.complete({'status': 'ok'});
    await test;
    await tester.pump();
    expect(find.text('Status: Connected'), findsOneWidget);

    await tester.pumpWidget(_host(controller));
    expect(find.text('Status: Connected'), findsOneWidget);
  });
}
