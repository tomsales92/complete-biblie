// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Complete Bible';

  @override
  String get taglineGenesisRevelation => 'De Gênesis a Apocalipse';

  @override
  String get createYourAccount => 'Crie sua conta';

  @override
  String get name => 'Nome';

  @override
  String get yourName => 'Seu nome';

  @override
  String get email => 'E-mail';

  @override
  String get emailHint => 'seu@email.com';

  @override
  String get password => 'Senha';

  @override
  String get state => 'Estado';

  @override
  String get birthDate => 'Data de nascimento';

  @override
  String get selectDate => 'Selecionar data';

  @override
  String get rememberEmail => 'Lembrar meu e-mail';

  @override
  String get pleaseWait => 'Aguarde...';

  @override
  String get createAccount => 'Criar conta';

  @override
  String get signIn => 'Entrar';

  @override
  String get forgotPassword => 'Esqueci minha senha';

  @override
  String get haveAccountSignIn => 'Já tenho conta — entrar';

  @override
  String get createAnAccount => 'Criar uma conta';

  @override
  String get fillEmailPassword => 'Preencha e-mail e senha.';

  @override
  String get fillRegisterFields => 'Preencha nome, estado e data de nascimento.';

  @override
  String get enterEmailToReset => 'Informe seu e-mail para redefinir a senha.';

  @override
  String get resetEmailSent => 'Enviamos um e-mail com instruções para redefinir sua senha.';

  @override
  String get errInvalidEmail => 'E-mail inválido.';

  @override
  String get errWrongCredentials => 'E-mail ou senha incorretos.';

  @override
  String get errEmailInUse => 'Este e-mail já está cadastrado.';

  @override
  String get errWeakPassword => 'A senha deve ter pelo menos 6 caracteres.';

  @override
  String get errNetwork => 'Sem conexão com a internet. Verifique sua rede e tente novamente.';

  @override
  String get errTooMany => 'Muitas tentativas. Aguarde um pouco e tente novamente.';

  @override
  String get errGeneric => 'Não foi possível concluir. Tente novamente.';

  @override
  String get settings => 'Configurações';

  @override
  String get account => 'Conta';

  @override
  String get dangerZone => 'Zona de risco';

  @override
  String get deleteAccount => 'Excluir conta';

  @override
  String get deleteAccountSubtitle => 'Remove permanentemente sua conta e seu histórico de leitura.';

  @override
  String get deleteAccountWarning => 'Isso vai apagar permanentemente sua conta e todo o seu histórico de leitura. Essa ação não pode ser desfeita.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Excluir';

  @override
  String get confirm => 'Confirmar';

  @override
  String get confirmPassword => 'Confirme sua senha';

  @override
  String get wrongPassword => 'Senha incorreta.';

  @override
  String get deleteFailed => 'Não foi possível excluir a conta. Tente novamente.';

  @override
  String hello(String name) {
    return 'Olá, $name';
  }

  @override
  String get signOut => 'Sair';

  @override
  String get yourBook => 'Seu livro';

  @override
  String get book => 'Livro';

  @override
  String get noChaptersToday => 'Nenhum capítulo lido hoje';

  @override
  String readToday(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capítulos',
      one: '1 capítulo',
    );
    return 'Lido hoje: $_temp0';
  }

  @override
  String errorWithMessage(String message) {
    return 'Erro: $message';
  }

  @override
  String get readingHistory => 'Histórico de leitura';

  @override
  String chaptersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capítulos',
      one: '1 capítulo',
    );
    return '$_temp0';
  }

  @override
  String get noReadsYet => 'Nenhuma leitura registrada ainda.';

  @override
  String chapAbbrev(int count) {
    return '$count cap.';
  }

  @override
  String get today => 'Hoje';

  @override
  String get yesterday => 'Ontem';

  @override
  String get panorama => 'PANORAMA';

  @override
  String get statRead => 'Lidos';

  @override
  String get statRemaining => 'Faltam';

  @override
  String get statChaptersPerDay => 'Cap./dia';

  @override
  String get statDaysRemaining => 'Dias restantes';

  @override
  String get completed => 'concluído';

  @override
  String get lightTheme => 'Tema claro';

  @override
  String get darkTheme => 'Tema escuro';

  @override
  String get confirmPasswordField => 'Confirmar senha';

  @override
  String get errPasswordMismatch => 'As senhas não coincidem.';

  @override
  String get passwordsMatch => 'As senhas coincidem.';
}
