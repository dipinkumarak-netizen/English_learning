import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(AppLocalizations.of(context)!.appName)),
    body: Center(
      child: Text(
        AppLocalizations.of(context)!.homeHeading,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    ),
  );
}
