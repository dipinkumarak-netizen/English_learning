import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app.dart';
import '../../../l10n/app_localizations.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        actions: [
          DropdownButton<Locale>(
            value: ref.watch(localeProvider),
            underline: const SizedBox.shrink(),
            items: const [
              DropdownMenuItem(value: Locale('ml'), child: Text('ml')),
              DropdownMenuItem(value: Locale('en'), child: Text('English')),
            ],
            onChanged: (value) {
              if (value != null) {
                ref.read(localeProvider.notifier).setLocale(value);
              }
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.welcomeMessage,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(l10n.comingSoon),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => context.go('/home'),
                child: Text(l10n.continueButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
