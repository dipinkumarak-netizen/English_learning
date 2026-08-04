import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import 'capability_status_providers.dart';

class BackendConnectionCard extends ConsumerWidget {
  const BackendConnectionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(capabilityStatusProvider);
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
            Text('Status: ${controller.connectionStatusLabel}'),
            if (controller.status != null)
              Text('Transport: ${controller.status!.transportLabel}'),
            if (controller.error != null && error == null)
              Text(
                controller.error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: controller.testing || error != null
                  ? null
                  : controller.testConnection,
              child: Text(controller.testing ? 'Testing…' : 'Test connection'),
            ),
          ],
        ),
      ),
    );
  }
}
