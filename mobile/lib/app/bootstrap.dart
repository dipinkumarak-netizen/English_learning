import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import '../core/logging/app_logger.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    AppLogger.instance.error(
      'Flutter framework error',
      details.exception,
      details.stack,
    );
  };
  runApp(const ProviderScope(child: NilaSpeakApp()));
}
