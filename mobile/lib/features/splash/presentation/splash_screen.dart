import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.auto_awesome, size: 64),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.appName,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => context.go('/welcome'),
            child: Text(AppLocalizations.of(context)!.continueButton),
          ),
        ],
      ),
    ),
  );
}
