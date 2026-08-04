import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authentication/presentation/auth_controller.dart';
import 'backend_connection_card.dart';
import 'capability_status_providers.dart';

class AISettingsScreen extends ConsumerStatefulWidget {
  const AISettingsScreen({super.key});
  @override
  ConsumerState<AISettingsScreen> createState() => _AISettingsScreenState();
}

class _AISettingsScreenState extends ConsumerState<AISettingsScreen> {
  final _key = TextEditingController();
  final Map<String, String> _providers = {};
  final Map<String, String?> _accountsFor = {};
  final Map<String, TextEditingController> _models = {};
  final Map<String, TextEditingController> _voices = {};
  String _accountProvider = 'openai';
  List<Map<String, dynamic>> _accounts = const [];
  List<Map<String, dynamic>> _capabilities = const [];
  bool _loading = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _key.dispose();
    for (final c in [..._models.values, ..._voices.values]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<String?> get _token =>
      ref.read(tokenStorageProvider).readAccessToken();

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final client = ref.read(apiClientProvider);
      final token = await _token;
      final accounts = await client.get(
        '/api/v1/settings/provider-accounts',
        accessToken: token,
      );
      final capabilities = await client.get(
        '/api/v1/settings/provider-capabilities',
        accessToken: token,
      );
      if (!mounted) return;
      setState(() {
        _accounts = (accounts['accounts'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .toList();
        _capabilities =
            (capabilities['capabilities'] as List<dynamic>? ?? const [])
                .whereType<Map<String, dynamic>>()
                .toList();
        for (final item in _capabilities) {
          final name = item['capability'] as String;
          _providers[name] = item['provider'] as String? ?? 'none';
          _accountsFor[name] = item['provider_account_id'] as String?;
          _models.putIfAbsent(
            name,
            () => TextEditingController(text: item['model'] as String? ?? ''),
          );
          _voices.putIfAbsent(
            name,
            () => TextEditingController(text: item['voice'] as String? ?? ''),
          );
        }
        _error = null;
      });
      await ref.read(capabilityStatusProvider).load();
    } catch (_) {
      if (mounted) setState(() => _error = 'AI settings could not be loaded.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _saveAccount() async {
    final allowed =
        ref.read(capabilityStatusProvider).status?.providerMutationsAllowed ==
        true;
    if (!allowed || _key.text.trim().isEmpty) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(apiClientProvider)
          .post(
            '/api/v1/settings/provider-accounts',
            accessToken: await _token,
            data: {'provider': _accountProvider, 'api_key': _key.text.trim()},
          );
      _key.clear();
      await _load();
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Provider account could not be saved.');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _testAccount(String id) async {
    try {
      await ref
          .read(apiClientProvider)
          .post(
            '/api/v1/settings/provider-accounts/$id/test',
            accessToken: await _token,
          );
      await _load();
    } catch (_) {
      if (mounted) setState(() => _error = 'Provider connection test failed.');
    }
  }

  Future<void> _deleteAccount(String id) async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete provider account?'),
            content: const Text(
              'This removes the encrypted provider credential. Accounts in use cannot be deleted.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed) return;
    try {
      await ref
          .read(apiClientProvider)
          .delete(
            '/api/v1/settings/provider-accounts/$id',
            accessToken: await _token,
          );
      await _load();
    } catch (_) {
      if (mounted) {
        setState(
          () => _error =
              'Provider account could not be deleted or is still in use.',
        );
      }
    }
  }

  Future<void> _saveCapability(String capability) async {
    final provider = _providers[capability] ?? 'none';
    if (provider == 'gemini' && capability == 'stt') {
      setState(
        () => _error =
            'Gemini speech-to-text currently requires AAC audio; M4A conversion is unavailable.',
      );
      return;
    }
    try {
      await ref
          .read(apiClientProvider)
          .put(
            '/api/v1/settings/provider-capabilities/$capability',
            accessToken: await _token,
            data: {
              'provider': provider,
              'provider_account_id':
                  provider == 'openai' || provider == 'gemini'
                  ? _accountsFor[capability]
                  : null,
              'enabled': provider != 'none',
              'model': _models[capability]?.text.trim(),
              'voice': capability == 'tts'
                  ? _voices[capability]?.text.trim()
                  : null,
            },
          );
      await _load();
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Capability settings could not be saved.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mutations =
        ref.watch(capabilityStatusProvider).status?.providerMutationsAllowed ==
        true;
    return Scaffold(
      appBar: AppBar(title: const Text('AI Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const BackendConnectionCard(),
          const SizedBox(height: 20),
          const Text(
            'Provider accounts',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Keys are encrypted by the backend and never shown again.',
          ),
          if (_error != null)
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          if (_loading) const LinearProgressIndicator(),
          ..._accounts.map(
            (account) => Card(
              child: ListTile(
                title: Text(
                  account['provider'] == 'gemini' ? 'Google Gemini' : 'OpenAI',
                ),
                subtitle: Text(
                  'Key ends ${account['key_last4'] ?? '****'} • ${account['last_test_status'] ?? 'Not tested'}',
                ),
                trailing: Wrap(
                  children: [
                    IconButton(
                      tooltip: 'Test connection',
                      icon: const Icon(Icons.refresh),
                      onPressed: mutations
                          ? () => _testAccount(account['id'] as String)
                          : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: mutations
                          ? () => _deleteAccount(account['id'] as String)
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _accountProvider,
                    items: const [
                      DropdownMenuItem(value: 'openai', child: Text('OpenAI')),
                      DropdownMenuItem(
                        value: 'gemini',
                        child: Text('Google Gemini'),
                      ),
                    ],
                    onChanged: mutations
                        ? (v) =>
                              setState(() => _accountProvider = v ?? 'openai')
                        : null,
                    decoration: const InputDecoration(labelText: 'Provider'),
                  ),
                  TextField(
                    controller: _key,
                    obscureText: true,
                    enabled: mutations,
                    decoration: const InputDecoration(labelText: 'API key'),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FilledButton(
                      onPressed:
                          _saving || !mutations || _key.text.trim().isEmpty
                          ? null
                          : _saveAccount,
                      child: Text(_saving ? 'Saving…' : 'Save securely'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Capabilities',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ..._capabilities.map((item) => _capabilityCard(item, mutations)),
        ],
      ),
    );
  }

  Widget _capabilityCard(Map<String, dynamic> item, bool mutations) {
    final capability = item['capability'] as String;
    final provider = _providers[capability] ?? 'none';
    final accounts = _accounts.where((a) => a['provider'] == provider).toList();
    final selected = accounts.any((a) => a['id'] == _accountsFor[capability])
        ? _accountsFor[capability]
        : null;
    return Card(
      child: ExpansionTile(
        title: Text(_capabilityTitle(capability)),
        subtitle: Text(
          '${item['provider_type'] ?? 'disabled'} • ${item['credential_source'] ?? 'none'}${item['preview'] == true ? ' • Preview' : ''}',
        ),
        trailing: Text(item['usable'] == true ? 'Ready' : 'Setup required'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: provider,
                  items: const [
                    DropdownMenuItem(value: 'none', child: Text('Disabled')),
                    DropdownMenuItem(value: 'mock', child: Text('Mock')),
                    DropdownMenuItem(value: 'openai', child: Text('OpenAI')),
                    DropdownMenuItem(
                      value: 'gemini',
                      child: Text('Google Gemini'),
                    ),
                  ],
                  onChanged: mutations
                      ? (v) =>
                            setState(() => _providers[capability] = v ?? 'none')
                      : null,
                  decoration: const InputDecoration(labelText: 'Provider'),
                ),
                if (provider == 'openai' || provider == 'gemini')
                  DropdownButtonFormField<String>(
                    initialValue: selected,
                    items: accounts
                        .map(
                          (a) => DropdownMenuItem(
                            value: a['id'] as String,
                            child: Text(
                              'Account ••••${a['key_last4'] ?? '****'}',
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: mutations
                        ? (v) => setState(() => _accountsFor[capability] = v)
                        : null,
                    decoration: const InputDecoration(
                      labelText: 'Encrypted provider account',
                    ),
                  ),
                TextField(
                  controller: _models[capability],
                  enabled: mutations,
                  decoration: const InputDecoration(labelText: 'Model'),
                ),
                if (capability == 'tts')
                  TextField(
                    controller: _voices[capability],
                    enabled: mutations,
                    decoration: const InputDecoration(labelText: 'Voice'),
                  ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton(
                    onPressed: mutations
                        ? () => _saveCapability(capability)
                        : null,
                    child: const Text('Save capability'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _capabilityTitle(String capability) => switch (capability) {
    'ai' => 'AI Tutor',
    'stt' => 'Speech-to-Text',
    'tts' => 'Text-to-Speech',
    _ => 'Capability',
  };
}
