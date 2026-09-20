// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Complete Bible';

  @override
  String get taglineGenesisRevelation => 'From Genesis to Revelation';

  @override
  String get createYourAccount => 'Create your account';

  @override
  String get name => 'Name';

  @override
  String get yourName => 'Your name';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'you@email.com';

  @override
  String get password => 'Password';

  @override
  String get state => 'State';

  @override
  String get birthDate => 'Date of birth';

  @override
  String get selectDate => 'Select date';

  @override
  String get rememberEmail => 'Remember my email';

  @override
  String get pleaseWait => 'Please wait...';

  @override
  String get createAccount => 'Create account';

  @override
  String get signIn => 'Sign in';

  @override
  String get forgotPassword => 'Forgot my password';

  @override
  String get haveAccountSignIn => 'I already have an account — sign in';

  @override
  String get createAnAccount => 'Create an account';

  @override
  String get fillEmailPassword => 'Enter your email and password.';

  @override
  String get fillRegisterFields => 'Enter your name, state and date of birth.';

  @override
  String get enterEmailToReset => 'Enter your email to reset your password.';

  @override
  String get resetEmailSent => 'We sent you an email with instructions to reset your password.';

  @override
  String get errInvalidEmail => 'Invalid email.';

  @override
  String get errWrongCredentials => 'Incorrect email or password.';

  @override
  String get errEmailInUse => 'This email is already registered.';

  @override
  String get errWeakPassword => 'Password must be at least 6 characters.';

  @override
  String get errNetwork => 'No internet connection. Check your network and try again.';

  @override
  String get errTooMany => 'Too many attempts. Please wait a moment and try again.';

  @override
  String get errGeneric => 'Something went wrong. Please try again.';

  @override
  String get settings => 'Settings';

  @override
  String get account => 'Account';

  @override
  String get dangerZone => 'Danger zone';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountSubtitle => 'Permanently removes your account and reading history.';

  @override
  String get deleteAccountWarning => 'This will permanently delete your account and all your reading history. This action cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get confirm => 'Confirm';

  @override
  String get confirmPassword => 'Confirm your password';

  @override
  String get wrongPassword => 'Incorrect password.';

  @override
  String get deleteFailed => 'Could not delete the account. Please try again.';

  @override
  String hello(String name) {
    return 'Hello, $name';
  }

  @override
  String get signOut => 'Sign out';

  @override
  String get yourBook => 'Your book';

  @override
  String get book => 'Book';

  @override
  String get noChaptersToday => 'No chapters read today';

  @override
  String readToday(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chapters',
      one: '1 chapter',
    );
    return 'Read today: $_temp0';
  }

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get readingHistory => 'Reading history';

  @override
  String chaptersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chapters',
      one: '1 chapter',
    );
    return '$_temp0';
  }

  @override
  String get noReadsYet => 'No readings recorded yet.';

  @override
  String chapAbbrev(int count) {
    return '$count ch.';
  }

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get panorama => 'OVERVIEW';

  @override
  String get statRead => 'Read';

  @override
  String get statRemaining => 'Left';

  @override
  String get statChaptersPerDay => 'Ch./day';

  @override
  String get statDaysRemaining => 'Days left';

  @override
  String get completed => 'complete';

  @override
  String get lightTheme => 'Light theme';

  @override
  String get darkTheme => 'Dark theme';

  @override
  String get confirmPasswordField => 'Confirm password';

  @override
  String get errPasswordMismatch => 'Passwords do not match.';

  @override
  String get passwordsMatch => 'Passwords match.';
}
