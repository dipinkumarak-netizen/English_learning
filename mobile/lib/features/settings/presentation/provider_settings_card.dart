import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/provider_settings_repository.dart';
import '../data/capability_status.dart';
import 'capability_status_providers.dart';
import 'provider_settings_providers.dart';

class ProviderSettingsCard extends ConsumerWidget {
  const ProviderSettingsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(capabilityStatusProvider);
    final settings = ref.watch(providerSettingsProvider);
    if (status.loading || settings.loading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: LinearProgressIndicator(),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'AI Provider Settings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        if (status.status == null)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('Provider capability status is unavailable.'),
            ),
          )
        else ...[
          _CapabilityCard(
            capability: 'ai',
            title: 'AI Tutor',
            capabilityState: status.status!.ai,
            setting: settings.ai,
            transportAllowed: status.status!.providerMutationsAllowed,
          ),
          _CapabilityCard(
            capability: 'stt',
            title: 'Speech-to-Text',
            capabilityState: status.status!.stt,
            setting: settings.stt,
            transportAllowed: status.status!.providerMutationsAllowed,
          ),
          _CapabilityCard(
            capability: 'tts',
            title: 'Text-to-Speech',
            capabilityState: status.status!.tts,
            setting: settings.tts,
            transportAllowed: status.status!.providerMutationsAllowed,
          ),
        ],
        if (status.status != null && !status.status!.providerMutationsAllowed)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Provider credentials require an HTTPS backend connection.',
            ),
          ),
        if (settings.error != null)
          Text(
            settings.error!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
      ],
    );
  }
}

class _CapabilityCard extends ConsumerStatefulWidget {
  const _CapabilityCard({
    required this.capability,
    required this.title,
    required this.capabilityState,
    required this.setting,
    required this.transportAllowed,
  });
  final String capability;
  final String title;
  final CapabilityState capabilityState;
  final ProviderSetting? setting;
  final bool transportAllowed;

  @override
  ConsumerState<_CapabilityCard> createState() => _CapabilityCardState();
}

class _CapabilityCardState extends ConsumerState<_CapabilityCard> {
  late String _provider;
  late final TextEditingController _key;
  late final TextEditingController _model;
  late final TextEditingController _voice;
  bool _enabled = false;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    final setting = widget.setting;
    _provider = setting?.provider ?? 'none';
    _enabled = setting?.enabled ?? false;
    _key = TextEditingController();
    _model = TextEditingController(text: setting?.model ?? '');
    _voice = TextEditingController(text: setting?.voice ?? 'alloy');
  }

  @override
  void dispose() {
    _key.dispose();
    _model.dispose();
    _voice.dispose();
    super.dispose();
  }

  bool get _disabled => providerApiValue(_provider) == 'none';
  bool get _environmentManaged =>
      widget.capabilityState.credentialSource == 'environment';
  bool get _canTest =>
      widget.transportAllowed &&
      !_disabled &&
      _model.text.trim().isNotEmpty &&
      (_key.text.trim().isNotEmpty ||
          widget.capabilityState.credentialSource == 'environment');

  @override
  Widget build(BuildContext context) {
    final setting = widget.setting;
    final controller = ref.watch(providerSettingsProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              '${widget.capabilityState.label} • ${widget.capabilityState.sourceLabel}${setting?.keyLast4 == null ? '' : ' • key ends ${setting!.keyLast4}'}',
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: _provider,
              decoration: const InputDecoration(labelText: 'Provider'),
              items: const [
                DropdownMenuItem(value: 'none', child: Text('Disabled')),
                DropdownMenuItem(
                  value: 'mock',
                  child: Text('Mock (development)'),
                ),
                DropdownMenuItem(
                  value: 'openai',
                  child: Text('OpenAI-compatible'),
                ),
              ],
              onChanged: (value) => setState(() {
                _provider = value ?? 'none';
                if (_provider == 'none') {
                  _enabled = false;
                  _key.clear();
                  _model.clear();
                  _voice.clear();
                }
              }),
            ),
            TextField(
              controller: _model,
              decoration: InputDecoration(
                labelText: widget.capability == 'ai'
                    ? 'AI model'
                    : '${widget.capability.toUpperCase()} model',
              ),
              onChanged: (_) => setState(() {}),
              enabled: !_disabled,
            ),
            if (widget.capability == 'tts')
              TextField(
                controller: _voice,
                decoration: const InputDecoration(labelText: 'Tutor voice'),
                enabled: !_disabled,
              ),
            TextField(
              controller: _key,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: _environmentManaged
                    ? 'API key managed by server'
                    : 'API key (never shown again)',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              enabled:
                  !_disabled && !_environmentManaged && widget.transportAllowed,
            ),
            SwitchListTile(
              title: const Text('Enable provider'),
              value: _disabled ? false : _enabled,
              onChanged: _disabled || !widget.transportAllowed
                  ? null
                  : (value) => setState(() => _enabled = value),
              contentPadding: EdgeInsets.zero,
            ),
            Wrap(
              spacing: 8,
              children: [
                FilledButton(
                  onPressed:
                      controller.saving ||
                          !widget.transportAllowed ||
                          _environmentManaged
                      ? null
                      : _save,
                  child: const Text('Save securely'),
                ),
                OutlinedButton(
                  onPressed: controller.testing || !_canTest ? null : _test,
                  child: const Text('Test connection'),
                ),
                TextButton(
                  onPressed:
                      controller.saving ||
                          setting == null ||
                          !widget.transportAllowed
                      ? null
                      : _delete,
                  child: const Text('Delete credential'),
                ),
              ],
            ),
            if (_environmentManaged)
              const Text(
                'This provider is configured by the server environment and cannot be edited here.',
              ),
            if (controller.testMessage != null) Text(controller.testMessage!),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final ok = await ref
        .read(providerSettingsProvider)
        .saveCapability(
          capability: widget.capability,
          provider: _provider,
          apiKey: _key.text.trim(),
          model: _model.text.trim(),
          voice: widget.capability == 'tts' ? _voice.text.trim() : '',
          enabled: _enabled,
          transportAllowsMutation: widget.transportAllowed,
        );
    if (ok) _key.clear();
  }

  Future<void> _test() async {
    await ref
        .read(providerSettingsProvider)
        .testConnection(
          capability: widget.capability,
          provider: _provider,
          apiKey: _key.text.trim(),
          model: _model.text.trim(),
          voice: _voice.text.trim(),
          transportAllowsMutation: widget.transportAllowed,
        );
  }

  Future<void> _delete() async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete credential?'),
            content: const Text(
              'The encrypted account credential will be deleted from the backend.',
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
    if (confirmed) {
      await ref
          .read(providerSettingsProvider)
          .deleteCapability(
            widget.capability,
            transportAllowsMutation: widget.transportAllowed,
          );
    }
  }
}
