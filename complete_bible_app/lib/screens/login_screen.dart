import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/brazil_states.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/theme_controller.dart';
import '../services/user_profile_service.dart';
import '../widgets/theme_toggle_button.dart';

const _rememberedEmailKey = 'rememberedEmail';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.authService,
    required this.themeController,
    required this.userProfileService,
  });

  final AuthService authService;
  final ThemeController themeController;
  final UserProfileService userProfileService;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isRegister = false;
  bool _rememberEmail = true;
  bool _loading = false;
  String? _error;
  String? _info;
  String? _selectedState;
  DateTime? _birthDate;

  @override
  void initState() {
    super.initState();
    _loadRememberedEmail();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadRememberedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString(_rememberedEmailKey);
    if (savedEmail != null && mounted) {
      setState(() {
        _emailController.text = savedEmail;
        _rememberEmail = true;
      });
    }
  }

  Future<void> _persistRememberedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberEmail) {
      await prefs.setString(_rememberedEmailKey, _emailController.text.trim());
    } else {
      await prefs.remove(_rememberedEmailKey);
    }
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 20, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final name = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Preencha e-mail e senha.');
      return;
    }

    if (_isRegister &&
        (name.isEmpty || _selectedState == null || _birthDate == null)) {
      setState(() => _error = 'Preencha nome, estado e data de nascimento.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _info = null;
    });

    try {
      if (_isRegister) {
        await widget.authService.register(email, password);
        final uid = widget.authService.currentUser?.uid;
        if (uid != null) {
          await widget.userProfileService.saveProfile(
            uid,
            UserProfile(
              name: name,
              state: _selectedState!,
              birthDate:
                  '${_birthDate!.year.toString().padLeft(4, '0')}-'
                  '${_birthDate!.month.toString().padLeft(2, '0')}-'
                  '${_birthDate!.day.toString().padLeft(2, '0')}',
            ),
          );
        }
      } else {
        await widget.authService.login(email, password);
      }
      await _persistRememberedEmail();
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _mapError(e.code));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _error = 'Informe seu e-mail para redefinir a senha.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _info = null;
    });

    try {
      await widget.authService.resetPassword(email);
      setState(() {
        _info = 'Enviamos um e-mail com instruções para redefinir sua senha.';
      });
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _mapError(e.code));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toggleMode() {
    setState(() {
      _isRegister = !_isRegister;
      _error = null;
      _info = null;
    });
  }

  String _mapError(String? code) {
    switch (code) {
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-mail ou senha incorretos.';
      case 'email-already-in-use':
        return 'Este e-mail já está cadastrado.';
      case 'weak-password':
        return 'A senha deve ter pelo menos 6 caracteres.';
      case 'network-request-failed':
        return 'Sem conexão com a internet. Verifique sua rede e tente novamente.';
      case 'too-many-requests':
        return 'Muitas tentativas. Aguarde um pouco e tente novamente.';
      default:
        return 'Não foi possível concluir. Tente novamente.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 380),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 84,
                        height: 84,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Image.asset(
                          'assets/icon/mark-transparent.png',
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Complete Bible',
                        textAlign: TextAlign.center,
                        style: textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _isRegister
                            ? 'Crie sua conta'
                            : 'De Gênesis a Apocalipse',
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (_isRegister) ...[
                                TextField(
                                  controller: _nameController,
                                  enabled: !_loading,
                                  textCapitalization:
                                      TextCapitalization.words,
                                  autofillHints: const [AutofillHints.name],
                                  decoration: const InputDecoration(
                                    labelText: 'Nome',
                                    hintText: 'Seu nome',
                                  ),
                                ),
                                const SizedBox(height: 14),
                              ],
                              TextField(
                                controller: _emailController,
                                enabled: !_loading,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
                                decoration: const InputDecoration(
                                  labelText: 'E-mail',
                                  hintText: 'seu@email.com',
                                ),
                              ),
                              const SizedBox(height: 14),
                              TextField(
                                controller: _passwordController,
                                enabled: !_loading,
                                obscureText: true,
                                autofillHints: const [AutofillHints.password],
                                decoration: const InputDecoration(
                                  labelText: 'Senha',
                                  hintText: '••••••••',
                                ),
                                onSubmitted: (_) => _submit(),
                              ),
                              if (_isRegister) ...[
                                const SizedBox(height: 14),
                                DropdownButtonFormField<String>(
                                  value: _selectedState,
                                  decoration: const InputDecoration(
                                    labelText: 'Estado',
                                  ),
                                  items: brazilStates
                                      .map(
                                        (state) => DropdownMenuItem(
                                          value: state.code,
                                          child: Text(state.name),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: _loading
                                      ? null
                                      : (value) => setState(
                                          () => _selectedState = value,
                                        ),
                                ),
                                const SizedBox(height: 14),
                                InkWell(
                                  onTap: _loading ? null : _pickBirthDate,
                                  borderRadius: BorderRadius.circular(18),
                                  child: InputDecorator(
                                    decoration: const InputDecoration(
                                      labelText: 'Data de nascimento',
                                    ),
                                    child: Text(
                                      _birthDate == null
                                          ? 'Selecionar data'
                                          : '${_birthDate!.day.toString().padLeft(2, '0')}/'
                                                '${_birthDate!.month.toString().padLeft(2, '0')}/'
                                                '${_birthDate!.year}',
                                    ),
                                  ),
                                ),
                              ],
                              if (!_isRegister)
                                CheckboxListTile(
                                  value: _rememberEmail,
                                  onChanged: _loading
                                      ? null
                                      : (value) => setState(
                                          () => _rememberEmail = value ?? true,
                                        ),
                                  title: const Text('Lembrar meu e-mail'),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                ),
                              if (_error != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  _error!,
                                  style: TextStyle(
                                    color: scheme.error,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                              if (_info != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  _info!,
                                  style: TextStyle(
                                    color: scheme.primary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 18),
                              FilledButton(
                                onPressed: _loading ? null : _submit,
                                child: Text(
                                  _loading
                                      ? 'Aguarde...'
                                      : (_isRegister
                                            ? 'Criar conta'
                                            : 'Entrar'),
                                ),
                              ),
                              if (!_isRegister) ...[
                                const SizedBox(height: 4),
                                TextButton(
                                  onPressed: _loading ? null : _forgotPassword,
                                  child: const Text('Esqueci minha senha'),
                                ),
                              ],
                              TextButton(
                                onPressed: _loading ? null : _toggleMode,
                                child: Text(
                                  _isRegister
                                      ? 'Já tenho conta — entrar'
                                      : 'Criar uma conta',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: ThemeToggleButton(themeController: widget.themeController),
            ),
          ],
        ),
      ),
    );
  }
}
