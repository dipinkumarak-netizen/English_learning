import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../authentication/presentation/auth_controller.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});
  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Map<String, dynamic>? _profile;
  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile)),
      body: _profile == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                ListTile(
                  title: Text(l10n.applicationLanguage),
                  subtitle: Text(
                    _profile!['application_language']?.toString() ?? '',
                  ),
                ),
                ListTile(
                  title: Text(l10n.nativeLanguage),
                  subtitle: Text(
                    _profile!['native_language']?.toString() ?? '',
                  ),
                ),
                ListTile(
                  title: Text(l10n.explanationLanguage),
                  subtitle: Text(
                    _profile!['explanation_language']?.toString() ?? '',
                  ),
                ),
                ListTile(
                  title: Text(l10n.dailyStudyTime),
                  subtitle: Text(
                    '${_profile!['daily_study_minutes'] ?? '-'} ${l10n.minutes}',
                  ),
                ),
                const SizedBox(height: 24),
                OutlinedButton(
                  onPressed: () => _confirmLogout(l10n),
                  child: Text(l10n.logout),
                ),
              ],
            ),
    );
  }

  Future<void> _load() async {
    final token = await ref.read(tokenStorageProvider).readAccessToken();
    if (token == null) return;
    try {
      final profile = await ref
          .read(apiClientProvider)
          .get('/api/v1/profile', accessToken: token);
      if (mounted) setState(() => _profile = profile);
    } catch (_) {
      if (mounted) setState(() => _profile = {});
    }
  }

  Future<void> _confirmLogout(AppLocalizations l10n) async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.logout),
            content: Text(l10n.logoutConfirm),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.logout),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed) return;
    await ref.read(authStateProvider.notifier).signOut();
    if (mounted) context.go('/auth');
  }
}
