import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';
import '../services/bible_service.dart';
import '../services/user_profile_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.user,
    required this.authService,
    required this.bibleService,
    required this.userProfileService,
  });

  final User user;
  final AuthService authService;
  final BibleService bibleService;
  final UserProfileService userProfileService;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _deleting = false;

  Future<void> _confirmDeleteAccount() async {
    final l10n = AppLocalizations.of(context);
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(l10n.deleteAccount),
            content: Text(l10n.deleteAccountWarning),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  l10n.delete,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
    );

    if (shouldDelete != true || !mounted) return;

    final password = await _promptPassword();
    if (password == null || !mounted) return;

    setState(() => _deleting = true);
    try {
      await widget.authService.reauthenticateWithPassword(password);
      await widget.bibleService.deleteAllReads(widget.user.uid);
      await widget.userProfileService.deleteProfile(widget.user.uid);
      await widget.authService.deleteAccount();
      // Signing out swaps the root screen to login; drop this pushed route so
      // it doesn't stay on top with a spinner.
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      debugPrint('Delete account failed: ${e.code} ${e.message}');
      if (!mounted) return;
      setState(() => _deleting = false);
      final message =
          e.code == 'wrong-password' || e.code == 'invalid-credential'
              ? l10n.wrongPassword
              : l10n.deleteFailed;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      debugPrint('Delete account failed: $e');
      if (!mounted) return;
      setState(() => _deleting = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.deleteFailed)));
    }
  }

  Future<String?> _promptPassword() async {
    final password = await showDialog<String>(
      context: context,
      builder: (context) => const _PasswordDialog(),
    );
    if (password == null || password.isEmpty) return null;
    return password;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(l10n.account, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              widget.user.email ?? '',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 32),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Text(
              l10n.dangerZone,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: scheme.error),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.delete_forever_rounded, color: scheme.error),
              title: Text(
                l10n.deleteAccount,
                style: TextStyle(color: scheme.error),
              ),
              subtitle: Text(l10n.deleteAccountSubtitle),
              onTap: _deleting ? null : _confirmDeleteAccount,
              trailing:
                  _deleting
                      ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : null,
            ),
          ],
        ),
      ),
    );
  }
}

// Owns its controller so it is disposed only after the dialog's exit
// animation has finished.
class _PasswordDialog extends StatefulWidget {
  const _PasswordDialog();

  @override
  State<_PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<_PasswordDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.confirmPassword),
      content: TextField(
        controller: _controller,
        obscureText: true,
        autofocus: true,
        decoration: InputDecoration(labelText: l10n.password),
        onSubmitted: (value) => Navigator.of(context).pop(value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: Text(l10n.confirm),
        ),
      ],
    );
  }
}
