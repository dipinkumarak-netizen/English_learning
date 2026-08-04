import '../../../core/network/api_client.dart';
import 'capability_status.dart';

class CapabilityStatusRepository {
  CapabilityStatusRepository(this._client, this._readToken);
  final ApiClient _client;
  final Future<String?> Function() _readToken;

  Future<CapabilityStatus> fetch() async => CapabilityStatus.fromJson(
    await _client.get('/api/v1/capabilities', accessToken: await _readToken()),
  );
}
