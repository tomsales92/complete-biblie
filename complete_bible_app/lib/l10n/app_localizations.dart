import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt')
  ];

  /// No description provided for @appTitle.
  ///
  /// In pt, this message translates to:
  /// **'Complete Bible'**
  String get appTitle;

  /// No description provided for @taglineGenesisRevelation.
  ///
  /// In pt, this message translates to:
  /// **'De Gênesis a Apocalipse'**
  String get taglineGenesisRevelation;

  /// No description provided for @createYourAccount.
  ///
  /// In pt, this message translates to:
  /// **'Crie sua conta'**
  String get createYourAccount;

  /// No description provided for @name.
  ///
  /// In pt, this message translates to:
  /// **'Nome'**
  String get name;

  /// No description provided for @yourName.
  ///
  /// In pt, this message translates to:
  /// **'Seu nome'**
  String get yourName;

  /// No description provided for @email.
  ///
  /// In pt, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In pt, this message translates to:
  /// **'seu@email.com'**
  String get emailHint;

  /// No description provided for @password.
  ///
  /// In pt, this message translates to:
  /// **'Senha'**
  String get password;

  /// No description provided for @state.
  ///
  /// In pt, this message translates to:
  /// **'Estado'**
  String get state;

  /// No description provided for @birthDate.
  ///
  /// In pt, this message translates to:
  /// **'Data de nascimento'**
  String get birthDate;

  /// No description provided for @selectDate.
  ///
  /// In pt, this message translates to:
  /// **'Selecionar data'**
  String get selectDate;

  /// No description provided for @rememberEmail.
  ///
  /// In pt, this message translates to:
  /// **'Lembrar meu e-mail'**
  String get rememberEmail;

  /// No description provided for @pleaseWait.
  ///
  /// In pt, this message translates to:
  /// **'Aguarde...'**
  String get pleaseWait;

  /// No description provided for @createAccount.
  ///
  /// In pt, this message translates to:
  /// **'Criar conta'**
  String get createAccount;

  /// No description provided for @signIn.
  ///
  /// In pt, this message translates to:
  /// **'Entrar'**
  String get signIn;

  /// No description provided for @forgotPassword.
  ///
  /// In pt, this message translates to:
  /// **'Esqueci minha senha'**
  String get forgotPassword;

  /// No description provided for @haveAccountSignIn.
  ///
  /// In pt, this message translates to:
  /// **'Já tenho conta — entrar'**
  String get haveAccountSignIn;

  /// No description provided for @createAnAccount.
  ///
  /// In pt, this message translates to:
  /// **'Criar uma conta'**
  String get createAnAccount;

  /// No description provided for @fillEmailPassword.
  ///
  /// In pt, this message translates to:
  /// **'Preencha e-mail e senha.'**
  String get fillEmailPassword;

  /// No description provided for @fillRegisterFields.
  ///
  /// In pt, this message translates to:
  /// **'Preencha nome, estado e data de nascimento.'**
  String get fillRegisterFields;

  /// No description provided for @enterEmailToReset.
  ///
  /// In pt, this message translates to:
  /// **'Informe seu e-mail para redefinir a senha.'**
  String get enterEmailToReset;

  /// No description provided for @resetEmailSent.
  ///
  /// In pt, this message translates to:
  /// **'Enviamos um e-mail com instruções para redefinir sua senha.'**
  String get resetEmailSent;

  /// No description provided for @errInvalidEmail.
  ///
  /// In pt, this message translates to:
  /// **'E-mail inválido.'**
  String get errInvalidEmail;

  /// No description provided for @errWrongCredentials.
  ///
  /// In pt, this message translates to:
  /// **'E-mail ou senha incorretos.'**
  String get errWrongCredentials;

  /// No description provided for @errEmailInUse.
  ///
  /// In pt, this message translates to:
  /// **'Este e-mail já está cadastrado.'**
  String get errEmailInUse;

  /// No description provided for @errWeakPassword.
  ///
  /// In pt, this message translates to:
  /// **'A senha deve ter pelo menos 6 caracteres.'**
  String get errWeakPassword;

  /// No description provided for @errNetwork.
  ///
  /// In pt, this message translates to:
  /// **'Sem conexão com a internet. Verifique sua rede e tente novamente.'**
  String get errNetwork;

  /// No description provided for @errTooMany.
  ///
  /// In pt, this message translates to:
  /// **'Muitas tentativas. Aguarde um pouco e tente novamente.'**
  String get errTooMany;

  /// No description provided for @errGeneric.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível concluir. Tente novamente.'**
  String get errGeneric;

  /// No description provided for @settings.
  ///
  /// In pt, this message translates to:
  /// **'Configurações'**
  String get settings;

  /// No description provided for @account.
  ///
  /// In pt, this message translates to:
  /// **'Conta'**
  String get account;

  /// No description provided for @dangerZone.
  ///
  /// In pt, this message translates to:
  /// **'Zona de risco'**
  String get dangerZone;

  /// No description provided for @deleteAccount.
  ///
  /// In pt, this message translates to:
  /// **'Excluir conta'**
  String get deleteAccount;

  /// No description provided for @deleteAccountSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Remove permanentemente sua conta e seu histórico de leitura.'**
  String get deleteAccountSubtitle;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In pt, this message translates to:
  /// **'Isso vai apagar permanentemente sua conta e todo o seu histórico de leitura. Essa ação não pode ser desfeita.'**
  String get deleteAccountWarning;

  /// No description provided for @cancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In pt, this message translates to:
  /// **'Excluir'**
  String get delete;

  /// No description provided for @confirm.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar'**
  String get confirm;

  /// No description provided for @confirmPassword.
  ///
  /// In pt, this message translates to:
  /// **'Confirme sua senha'**
  String get confirmPassword;

  /// No description provided for @wrongPassword.
  ///
  /// In pt, this message translates to:
  /// **'Senha incorreta.'**
  String get wrongPassword;

  /// No description provided for @deleteFailed.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível excluir a conta. Tente novamente.'**
  String get deleteFailed;

  /// No description provided for @hello.
  ///
  /// In pt, this message translates to:
  /// **'Olá, {name}'**
  String hello(String name);

  /// No description provided for @signOut.
  ///
  /// In pt, this message translates to:
  /// **'Sair'**
  String get signOut;

  /// No description provided for @yourBook.
  ///
  /// In pt, this message translates to:
  /// **'Seu livro'**
  String get yourBook;

  /// No description provided for @book.
  ///
  /// In pt, this message translates to:
  /// **'Livro'**
  String get book;

  /// No description provided for @noChaptersToday.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum capítulo lido hoje'**
  String get noChaptersToday;

  /// No description provided for @readToday.
  ///
  /// In pt, this message translates to:
  /// **'Lido hoje: {count, plural, =1{1 capítulo} other{{count} capítulos}}'**
  String readToday(int count);

  /// No description provided for @errorWithMessage.
  ///
  /// In pt, this message translates to:
  /// **'Erro: {message}'**
  String errorWithMessage(String message);

  /// No description provided for @readingHistory.
  ///
  /// In pt, this message translates to:
  /// **'Histórico de leitura'**
  String get readingHistory;

  /// No description provided for @chaptersCount.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{1 capítulo} other{{count} capítulos}}'**
  String chaptersCount(int count);

  /// No description provided for @noReadsYet.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma leitura registrada ainda.'**
  String get noReadsYet;

  /// No description provided for @chapAbbrev.
  ///
  /// In pt, this message translates to:
  /// **'{count} cap.'**
  String chapAbbrev(int count);

  /// No description provided for @today.
  ///
  /// In pt, this message translates to:
  /// **'Hoje'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In pt, this message translates to:
  /// **'Ontem'**
  String get yesterday;

  /// No description provided for @panorama.
  ///
  /// In pt, this message translates to:
  /// **'PANORAMA'**
  String get panorama;

  /// No description provided for @statRead.
  ///
  /// In pt, this message translates to:
  /// **'Lidos'**
  String get statRead;

  /// No description provided for @statRemaining.
  ///
  /// In pt, this message translates to:
  /// **'Faltam'**
  String get statRemaining;

  /// No description provided for @statChaptersPerDay.
  ///
  /// In pt, this message translates to:
  /// **'Cap./dia'**
  String get statChaptersPerDay;

  /// No description provided for @statDaysRemaining.
  ///
  /// In pt, this message translates to:
  /// **'Dias restantes'**
  String get statDaysRemaining;

  /// No description provided for @completed.
  ///
  /// In pt, this message translates to:
  /// **'concluído'**
  String get completed;

  /// No description provided for @lightTheme.
  ///
  /// In pt, this message translates to:
  /// **'Tema claro'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In pt, this message translates to:
  /// **'Tema escuro'**
  String get darkTheme;

  /// No description provided for @confirmPasswordField.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar senha'**
  String get confirmPasswordField;

  /// No description provided for @errPasswordMismatch.
  ///
  /// In pt, this message translates to:
  /// **'As senhas não coincidem.'**
  String get errPasswordMismatch;

  /// No description provided for @passwordsMatch.
  ///
  /// In pt, this message translates to:
  /// **'As senhas coincidem.'**
  String get passwordsMatch;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
