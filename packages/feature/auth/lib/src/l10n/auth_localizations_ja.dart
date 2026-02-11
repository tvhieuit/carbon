// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'auth_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AuthLocalizationsJa extends AuthLocalizations {
  AuthLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get loginTitle => '配達スタッフログイン';

  @override
  String get loginButton => 'ログイン';

  @override
  String get registerTitle => '登録';

  @override
  String get registerButton => '登録';

  @override
  String get emailLabel => 'メールアドレス';

  @override
  String get emailHint => 'メールアドレス';

  @override
  String get emailRequired => 'メールアドレスを入力してください';

  @override
  String get passwordLabel => 'パスワード';

  @override
  String get passwordHint => 'パスワードを入力してください';

  @override
  String get passwordRequired => 'パスワードを入力してください';

  @override
  String get passwordHelper => '大文字、小文字、数字を含む少なくとも8文字';

  @override
  String get confirmPasswordLabel => 'パスワード再入力';

  @override
  String get confirmPasswordHint => 'パスワードを再入力してください';

  @override
  String get confirmPasswordRequired => 'パスワードを再入力してください';

  @override
  String get passwordsDoNotMatch => 'パスワードが一致しません';

  @override
  String get fullNameLabel => 'お名前';

  @override
  String get fullNameHint => 'お名前を入力してください';

  @override
  String get fullNameRequired => 'お名前を入力してください';

  @override
  String get phoneLabel => '電話番号（任意）';

  @override
  String get phoneHint => '電話番号を入力してください';

  @override
  String get forgotPassword => 'パスワードを忘れた方はこちら';

  @override
  String get noAccount => 'アカウントをお持ちでないですか？';

  @override
  String get alreadyHaveAccount => 'すでにアカウントをお持ちですか？';
}
