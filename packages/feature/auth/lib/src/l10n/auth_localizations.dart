import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'auth_localizations_en.dart';
import 'auth_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AuthLocalizations
/// returned by `AuthLocalizations.of(context)`.
///
/// Applications need to include `AuthLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/auth_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AuthLocalizations.localizationsDelegates,
///   supportedLocales: AuthLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AuthLocalizations.supportedLocales
/// property.
abstract class AuthLocalizations {
  AuthLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AuthLocalizations of(BuildContext context) {
    return Localizations.of<AuthLocalizations>(context, AuthLocalizations)!;
  }

  static const LocalizationsDelegate<AuthLocalizations> delegate = _AuthLocalizationsDelegate();

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
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('ja')];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'CarbonGauge'**
  String get appName;

  /// Title for login page
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// Title for register page
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerTitle;

  /// Register button text
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerButton;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// Email field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailHint;

  /// Email required validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get emailRequired;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// Password field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// Password required validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordRequired;

  /// Password requirements helper text
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters with uppercase, lowercase, and number'**
  String get passwordHelper;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// Confirm password field hint
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmPasswordHint;

  /// Confirm password required validation message
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirmPasswordRequired;

  /// Passwords mismatch validation message
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Full name field label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// Full name field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get fullNameHint;

  /// Full name required validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get fullNameRequired;

  /// Phone field label
  ///
  /// In en, this message translates to:
  /// **'Phone (Optional)'**
  String get phoneLabel;

  /// Phone field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get phoneHint;

  /// Forgot password link text
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Text asking if user doesn't have account
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// Text asking if user already has account
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;
}

class _AuthLocalizationsDelegate extends LocalizationsDelegate<AuthLocalizations> {
  const _AuthLocalizationsDelegate();

  @override
  Future<AuthLocalizations> load(Locale locale) {
    return SynchronousFuture<AuthLocalizations>(lookupAuthLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AuthLocalizationsDelegate old) => false;
}

AuthLocalizations lookupAuthLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AuthLocalizationsEn();
    case 'ja':
      return AuthLocalizationsJa();
  }

  throw FlutterError(
    'AuthLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
