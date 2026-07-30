import 'package:flutter/material.dart';

import '../../../core/widgets/app_error_view.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, this.message});
  final String? message;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: AppErrorView(onRetry: () => Navigator.of(context).maybePop()),
  );
}
