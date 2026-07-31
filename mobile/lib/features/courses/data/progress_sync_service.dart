import 'dart:convert';

import '../../../core/local/app_database.dart';
import '../../../core/network/api_client.dart';

class ProgressSyncService {
  ProgressSyncService(this._client, this._database, this._readToken);
  final ApiClient _client;
  final AppDatabase _database;
  final Future<String?> Function() _readToken;

  Future<void> queue({
    required String operationId,
    required String operationType,
    required String entityId,
    required Map<String, dynamic> payload,
  }) => _database.enqueueProgress(
    PendingSyncOperationsCompanion.insert(
      clientOperationId: operationId,
      operationType: operationType,
      entityId: entityId,
      payload: jsonEncode(payload),
      createdAt: DateTime.now(),
    ),
  );

  Future<Map<String, dynamic>> sync() async {
    final token = await _readToken();
    if (token == null) throw StateError('No session');
    final pending = await _database.pendingOperations();
    if (pending.isEmpty) {
      return {'processed': <String>[], 'failed': <dynamic>[]};
    }
    final response = await _client.post(
      '/api/v1/progress/sync',
      accessToken: token,
      data: {
        'operations': pending
            .map(
              (operation) => {
                'client_operation_id': operation.clientOperationId,
                'operation_type': operation.operationType,
                'entity_id': operation.entityId,
                'payload': jsonDecode(operation.payload),
              },
            )
            .toList(),
      },
    );
    final processed = (response['processed'] as List<dynamic>? ?? const [])
        .cast<String>();
    for (final operation in pending.where(
      (item) => processed.contains(item.clientOperationId),
    )) {
      await (_database.delete(_database.pendingSyncOperations)..where(
            (row) => row.clientOperationId.equals(operation.clientOperationId),
          ))
          .go();
    }
    return response;
  }
}
