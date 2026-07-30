import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import 'auth_controller.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.signUpTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _name,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: l10n.displayName),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? l10n.genericError
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: l10n.email),
                  validator: (value) => value == null || !value.contains('@')
                      ? l10n.genericError
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _password,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: l10n.password,
                    helperText: l10n.passwordHint,
                    suffixIcon: IconButton(
                      tooltip: l10n.password,
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(
                        _obscure ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                  validator: (value) =>
                      value == null ||
                          value.length < 8 ||
                          !RegExp(r'[A-Za-z]').hasMatch(value) ||
                          !RegExp(r'\d').hasMatch(value)
                      ? l10n.passwordHint
                      : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _busy ? null : () => _submit(l10n),
                    child: _busy
                        ? const CircularProgressIndicator()
                        : Text(l10n.signUp),
                  ),
                ),
                TextButton(
                  onPressed: _busy ? null : () => context.go('/signin'),
                  child: Text(l10n.signIn),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit(AppLocalizations l10n) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      await ref
          .read(authStateProvider.notifier)
          .signUp(_email.text.trim(), _password.text, _name.text.trim());
      if (mounted) context.go('/onboarding');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.genericError)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
