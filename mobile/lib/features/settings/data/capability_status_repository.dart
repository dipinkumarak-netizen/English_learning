import '../../../core/network/api_client.dart';
import 'capability_status.dart';

abstract interface class CapabilityStatusSource {
  Future<Map<String, dynamic>> health();
  Future<CapabilityStatus> fetch();
}

class CapabilityStatusRepository implements CapabilityStatusSource {
  CapabilityStatusRepository(this._client, this._readToken);
  final ApiClient _client;
  final Future<String?> Function() _readToken;

  @override
  Future<Map<String, dynamic>> health() => _client.health();

  @override
  Future<CapabilityStatus> fetch() async => CapabilityStatus.fromJson(
    await _client.get('/api/v1/capabilities', accessToken: await _readToken()),
  );
}
