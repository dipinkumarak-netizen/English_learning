import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import 'provider_settings_providers.dart';

class ProviderSettingsCard extends ConsumerStatefulWidget {
  const ProviderSettingsCard({super.key});

  @override
  ConsumerState<ProviderSettingsCard> createState() =>
      _ProviderSettingsCardState();
}

class _ProviderSettingsCardState extends ConsumerState<ProviderSettingsCard> {
  final _apiKey = TextEditingController();
  final _aiModel = TextEditingController();
  final _sttModel = TextEditingController();
  final _ttsModel = TextEditingController();
  final _voice = TextEditingController();
  String _provider = 'none';
  bool _enabled = false;
  bool _obscure = true;
  bool _seeded = false;

  bool get _disabled => providerApiValue(_provider) == 'none';

  @override
  void dispose() {
    _apiKey.dispose();
    _aiModel.dispose();
    _sttModel.dispose();
    _ttsModel.dispose();
    _voice.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(providerSettingsProvider);
    if (!_seeded && state.providers.isNotEmpty) {
      _seeded = true;
      final ai = state.ai;
      final stt = state.stt;
      final tts = state.tts;
      _provider = providerApiValue(
        ai?.provider ?? stt?.provider ?? tts?.provider ?? 'none',
      );
      _enabled = ai?.enabled ?? false;
      _aiModel.text = ai?.model ?? '';
      _sttModel.text = stt?.model ?? '';
      _ttsModel.text = tts?.model ?? '';
      _voice.text = tts?.voice ?? 'alloy';
    }
    final insecure = Uri.tryParse(AppConfig.apiBaseUrl)?.scheme == 'http';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AI Provider Settings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: state.loading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (insecure)
                        const Text(
                          'Warning: this backend connection is HTTP. Use HTTPS for provider credentials outside local development.',
                          style: TextStyle(color: Colors.orange),
                        ),
                      DropdownButtonFormField<String>(
                        initialValue: _provider,
                        decoration: const InputDecoration(
                          labelText: 'Provider',
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'none',
                            child: Text('Disabled'),
                          ),
                          DropdownMenuItem(
                            value: 'mock',
                            child: Text('Mock (development)'),
                          ),
                          DropdownMenuItem(
                            value: 'openai',
                            child: Text('OpenAI-compatible'),
                          ),
                        ],
                        onChanged: (value) => _selectProvider(value!),
                      ),
                      TextField(
                        controller: _apiKey,
                        obscureText: _obscure,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: 'API key',
                          hintText: _keyHint(state),
                          suffixIcon: IconButton(
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                      TextField(
                        controller: _aiModel,
                        decoration: const InputDecoration(
                          labelText: 'AI model',
                        ),
                      ),
                      TextField(
                        controller: _sttModel,
                        decoration: const InputDecoration(
                          labelText: 'STT model',
                        ),
                      ),
                      TextField(
                        controller: _ttsModel,
                        decoration: const InputDecoration(
                          labelText: 'TTS model',
                        ),
                      ),
                      TextField(
                        controller: _voice,
                        decoration: const InputDecoration(
                          labelText: 'Tutor voice',
                        ),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Enable provider'),
                        value: _disabled ? false : _enabled,
                        onChanged: _disabled
                            ? null
                            : (value) => setState(() => _enabled = value),
                      ),
                      if (state.error != null)
                        Text(
                          state.error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      if (state.testMessage != null) Text(state.testMessage!),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          FilledButton(
                            onPressed: state.saving ? null : _save,
                            child: Text(
                              state.saving ? 'Saving…' : 'Save securely',
                            ),
                          ),
                          OutlinedButton(
                            onPressed: state.testing || _disabled
                                ? null
                                : _test,
                            child: Text(
                              state.testing ? 'Testing…' : 'Test connection',
                            ),
                          ),
                          TextButton(
                            onPressed: state.saving ? null : _delete,
                            child: const Text('Delete credential'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(_statusText(state)),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  String _keyHint(ProviderSettingsController state) {
    final last4 =
        state.ai?.keyLast4 ?? state.stt?.keyLast4 ?? state.tts?.keyLast4;
    return last4 == null
        ? 'Not configured'
        : 'Configured ••••$last4 (enter a new key to replace)';
  }

  String _statusText(ProviderSettingsController state) {
    final configured =
        state.ai?.configured == true ||
        state.stt?.configured == true ||
        state.tts?.configured == true;
    final last =
        state.ai?.lastTestStatus ??
        state.stt?.lastTestStatus ??
        state.tts?.lastTestStatus;
    final provider =
        state.ai?.provider ??
        state.stt?.provider ??
        state.tts?.provider ??
        'none';
    final providerLabel = provider == 'mock'
        ? 'mock (development)'
        : provider == 'openai'
        ? 'real provider'
        : 'disabled';
    return 'Provider: $providerLabel • Credential: ${configured ? 'configured' : 'not configured'}${last == null ? '' : ' • Last test: $last'}';
  }

  Future<void> _save() async {
    final controller = ref.read(providerSettingsProvider);
    final ok = await controller.save(
      provider: _provider,
      apiKey: _apiKey.text,
      aiModel: _aiModel.text,
      sttModel: _sttModel.text,
      ttsModel: _ttsModel.text,
      voice: _voice.text,
      enabled: _enabled,
    );
    if (ok) {
      _apiKey.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Provider settings saved securely.')),
        );
      }
    }
  }

  void _selectProvider(String value) {
    final apiValue = providerApiValue(value);
    setState(() {
      _provider = apiValue;
      if (apiValue == 'none') {
        _enabled = false;
        _apiKey.clear();
      }
    });
  }

  Future<void> _test() async {
    final controller = ref.read(providerSettingsProvider);
    await controller.testConnection(
      capability: 'ai',
      provider: _provider,
      apiKey: _apiKey.text,
      model: _aiModel.text,
      voice: _voice.text,
    );
  }

  Future<void> _delete() async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete provider credential?'),
            content: const Text(
              'This removes all saved provider credentials from the backend. Your API key will not be recoverable here.',
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
    final ok = await ref.read(providerSettingsProvider).deleteCredentials();
    if (ok) _apiKey.clear();
  }
}
