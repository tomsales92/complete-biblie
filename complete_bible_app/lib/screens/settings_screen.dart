import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir conta'),
        content: const Text(
          'Isso vai apagar permanentemente sua conta e todo o seu histórico '
          'de leitura. Essa ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Excluir',
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
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() => _deleting = false);
      final message = e.code == 'wrong-password' || e.code == 'invalid-credential'
          ? 'Senha incorreta.'
          : 'Não foi possível excluir a conta. Tente novamente.';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (_) {
      if (!mounted) return;
      setState(() => _deleting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível excluir a conta. Tente novamente.'),
        ),
      );
    }
  }

  Future<String?> _promptPassword() async {
    final controller = TextEditingController();
    final password = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirme sua senha'),
        content: TextField(
          controller: controller,
          obscureText: true,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Senha'),
          onSubmitted: (value) => Navigator.of(context).pop(value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (password == null || password.isEmpty) return null;
    return password;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Conta',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              widget.user.email ?? '',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Text(
              'Zona de risco',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: scheme.error),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.delete_forever_rounded, color: scheme.error),
              title: Text(
                'Excluir conta',
                style: TextStyle(color: scheme.error),
              ),
              subtitle: const Text(
                'Remove permanentemente sua conta e seu histórico de leitura.',
              ),
              onTap: _deleting ? null : _confirmDeleteAccount,
              trailing: _deleting
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
