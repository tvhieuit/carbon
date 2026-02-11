// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'auth_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AuthLocalizationsEn extends AuthLocalizations {
  AuthLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'CarbonGauge';

  @override
  String get loginTitle => 'Login';

  @override
  String get loginButton => 'Login';

  @override
  String get registerTitle => 'Register';

  @override
  String get registerButton => 'Register';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get emailRequired => 'Please enter your email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get passwordRequired => 'Please enter your password';

  @override
  String get passwordHelper => 'At least 8 characters with uppercase, lowercase, and number';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get confirmPasswordHint => 'Confirm your password';

  @override
  String get confirmPasswordRequired => 'Please confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get fullNameHint => 'Enter your full name';

  @override
  String get fullNameRequired => 'Please enter your name';

  @override
  String get phoneLabel => 'Phone (Optional)';

  @override
  String get phoneHint => 'Enter your phone number';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';
}
