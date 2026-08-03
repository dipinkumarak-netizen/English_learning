import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../authentication/presentation/auth_controller.dart';

class BackendConnectionCard extends ConsumerStatefulWidget {
  const BackendConnectionCard({super.key});

  @override
  ConsumerState<BackendConnectionCard> createState() =>
      _BackendConnectionCardState();
}

class _BackendConnectionCardState extends ConsumerState<BackendConnectionCard> {
  String _status = 'Not tested';
  bool _testing = false;

  @override
  Widget build(BuildContext context) {
    final error = AppConfig.apiBaseUrlError;
    final uri = Uri.tryParse(AppConfig.apiBaseUrl);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Backend connection',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              uri == null
                  ? 'Not configured'
                  : '${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}',
            ),
            if (error != null) ...[
              const SizedBox(height: 6),
              Text(
                error,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 8),
            Text('Status: $_status'),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _testing || error != null ? null : _test,
              child: Text(_testing ? 'Testing…' : 'Test connection'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _test() async {
    setState(() {
      _testing = true;
      _status = 'Testing…';
    });
    try {
      final result = await ref.read(apiClientProvider).health();
      setState(
        () => _status = result['status'] == 'ok' ? 'Connected' : 'Unreachable',
      );
    } catch (_) {
      setState(() => _status = 'Unreachable');
    } finally {
      if (mounted) setState(() => _testing = false);
    }
  }
}
