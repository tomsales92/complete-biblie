import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:intl/intl.dart';

import '../data/brazil_states.dart';
import '../l10n/app_localizations.dart';
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
  final _confirmPasswordController = TextEditingController();

  bool _isRegister = false;

  bool get _confirmMismatch =>
      _confirmPasswordController.text.isNotEmpty &&
      _confirmPasswordController.text != _passwordController.text;

  bool get _confirmMatches =>
      _confirmPasswordController.text.isNotEmpty &&
      _confirmPasswordController.text == _passwordController.text;

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
    _confirmPasswordController.dispose();
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
      setState(() => _error = AppLocalizations.of(context).fillEmailPassword);
      return;
    }

    if (_isRegister &&
        (name.isEmpty || _selectedState == null || _birthDate == null)) {
      setState(() => _error = AppLocalizations.of(context).fillRegisterFields);
      return;
    }

    if (_isRegister && password != _confirmPasswordController.text) {
      setState(
        () => _error = AppLocalizations.of(context).errPasswordMismatch,
      );
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
      if (!_isRegister) await _persistRememberedEmail();
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _mapError(e.code));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _error = AppLocalizations.of(context).enterEmailToReset);
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
        _info = AppLocalizations.of(context).resetEmailSent;
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
      // Leaving a form always resets it, submitted or not.
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      _nameController.clear();
      _selectedState = null;
      _birthDate = null;
    });
    if (!_isRegister) _loadRememberedEmail();
  }

  String _mapError(String? code) {
    final l10n = AppLocalizations.of(context);
    switch (code) {
      case 'invalid-email':
        return l10n.errInvalidEmail;
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return l10n.errWrongCredentials;
      case 'email-already-in-use':
        return l10n.errEmailInUse;
      case 'weak-password':
        return l10n.errWeakPassword;
      case 'network-request-failed':
        return l10n.errNetwork;
      case 'too-many-requests':
        return l10n.errTooMany;
      default:
        return l10n.errGeneric;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
                        child: Image.asset('assets/icon/mark-transparent.png'),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l10n.appTitle,
                        textAlign: TextAlign.center,
                        style: textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _isRegister
                            ? l10n.createYourAccount
                            : l10n.taglineGenesisRevelation,
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
                                  textCapitalization: TextCapitalization.words,
                                  autofillHints: const [AutofillHints.name],
                                  decoration: InputDecoration(
                                    labelText: l10n.name,
                                    hintText: l10n.yourName,
                                  ),
                                ),
                                const SizedBox(height: 14),
                              ],
                              TextField(
                                controller: _emailController,
                                enabled: !_loading,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
                                decoration: InputDecoration(
                                  labelText: l10n.email,
                                  hintText: l10n.emailHint,
                                ),
                              ),
                              const SizedBox(height: 14),
                              TextField(
                                controller: _passwordController,
                                enabled: !_loading,
                                obscureText: true,
                                autofillHints: const [AutofillHints.password],
                                decoration: InputDecoration(
                                  labelText: l10n.password,
                                  hintText: '••••••••',
                                ),
                                onChanged: (_) {
                                  if (_isRegister) setState(() {});
                                },
                                textInputAction: _isRegister
                                    ? TextInputAction.next
                                    : TextInputAction.done,
                                onSubmitted: (_) {
                                  if (!_isRegister) _submit();
                                },
                              ),
                              if (_isRegister) ...[
                                const SizedBox(height: 14),
                                TextField(
                                  controller: _confirmPasswordController,
                                  enabled: !_loading,
                                  obscureText: true,
                                  onChanged: (_) => setState(() {}),
                                  decoration: InputDecoration(
                                    labelText: l10n.confirmPasswordField,
                                    hintText: '••••••••',
                                    errorText: _confirmMismatch
                                        ? l10n.errPasswordMismatch
                                        : null,
                                    helperText: _confirmMatches
                                        ? l10n.passwordsMatch
                                        : null,
                                    helperStyle: TextStyle(
                                      color: scheme.primary,
                                    ),
                                    suffixIcon: _confirmMatches
                                        ? Icon(
                                            Icons.check_circle_rounded,
                                            color: scheme.primary,
                                          )
                                        : null,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                DropdownButtonFormField<String>(
                                  value: _selectedState,
                                  decoration: InputDecoration(
                                    labelText: l10n.state,
                                  ),
                                  items:
                                      brazilStates
                                          .map(
                                            (state) => DropdownMenuItem(
                                              value: state.code,
                                              child: Text(state.name),
                                            ),
                                          )
                                          .toList(),
                                  onChanged:
                                      _loading
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
                                    decoration: InputDecoration(
                                      labelText: l10n.birthDate,
                                    ),
                                    child: Text(
                                      _birthDate == null
                                          ? l10n.selectDate
                                          : DateFormat.yMd(
                                            Localizations.localeOf(
                                              context,
                                            ).toString(),
                                          ).format(_birthDate!),
                                    ),
                                  ),
                                ),
                              ],
                              if (!_isRegister)
                                CheckboxListTile(
                                  value: _rememberEmail,
                                  onChanged:
                                      _loading
                                          ? null
                                          : (value) => setState(
                                            () =>
                                                _rememberEmail = value ?? true,
                                          ),
                                  title: Text(l10n.rememberEmail),
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
                                      ? l10n.pleaseWait
                                      : (_isRegister
                                          ? l10n.createAccount
                                          : l10n.signIn),
                                ),
                              ),
                              if (!_isRegister) ...[
                                const SizedBox(height: 4),
                                TextButton(
                                  onPressed: _loading ? null : _forgotPassword,
                                  child: Text(l10n.forgotPassword),
                                ),
                              ],
                              TextButton(
                                onPressed: _loading ? null : _toggleMode,
                                child: Text(
                                  _isRegister
                                      ? l10n.haveAccountSignIn
                                      : l10n.createAnAccount,
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
