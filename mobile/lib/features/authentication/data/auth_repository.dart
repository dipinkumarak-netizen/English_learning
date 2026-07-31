import '../../../core/network/api_client.dart';
import 'token_storage.dart';

class AuthRepository {
  AuthRepository(this._client, this._tokens);
  final ApiClient _client;
  final TokenStorage _tokens;

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final response = await _client.post(
      '/api/v1/auth/register',
      data: {'email': email, 'password': password, 'display_name': displayName},
    );
    await _save(response);
    return response;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      '/api/v1/auth/login',
      data: {'email': email, 'password': password},
    );
    await _save(response);
    return response;
  }

  Future<Map<String, dynamic>> profile() async {
    final accessToken = await _tokens.readAccessToken();
    if (accessToken == null) throw StateError('No session');
    return _client.get('/api/v1/profile', accessToken: accessToken);
  }

  Future<void> logout() async {
    final accessToken = await _tokens.readAccessToken();
    final refreshToken = await _tokens.readRefreshToken();
    if (accessToken != null && refreshToken != null) {
      try {
        await _client.post(
          '/api/v1/auth/logout',
          data: {'refresh_token': refreshToken},
          accessToken: accessToken,
        );
      } finally {
        await _tokens.clear();
      }
    } else {
      await _tokens.clear();
    }
  }

  Future<void> clearTokens() => _tokens.clear();

  Future<void> deleteAccount() async {
    final accessToken = await _tokens.readAccessToken();
    if (accessToken != null) {
      await _client.delete('/api/v1/auth/account', accessToken: accessToken);
    }
    await _tokens.clear();
  }

  Future<void> _save(Map<String, dynamic> response) => _tokens.writeTokens(
    accessToken: response['access_token'] as String,
    refreshToken: response['refresh_token'] as String,
  );
}
