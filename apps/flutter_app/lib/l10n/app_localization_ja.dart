// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localization.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'Flutter App';

  @override
  String get welcome => 'ようこそ';

  @override
  String get save => '保存';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get loading => '読み込み中...';

  @override
  String get error => 'エラー';

  @override
  String get retry => '再試行';

  @override
  String get updateUser => 'ユーザー更新';

  @override
  String get userName => '名前';

  @override
  String get userEmail => 'メールアドレス';

  @override
  String get update => '更新';

  @override
  String get deleteUser => 'ユーザー削除';

  @override
  String get deleteConfirmation => 'このユーザーを削除してもよろしいですか？';

  @override
  String get userDetails => 'ユーザー詳細';

  @override
  String get userPhone => '電話番号';

  @override
  String get userCreated => '作成日';

  @override
  String get close => '閉じる';

  @override
  String get userList => 'ユーザー一覧';

  @override
  String get noUsersFound => 'ユーザーが見つかりません';

  @override
  String get reload => '再読み込み';

  @override
  String get unknown => '不明';

  @override
  String get openSettings => '設定を開く';

  @override
  String get allow => '許可';

  @override
  String get permissionPermanentlyDenied => '権限が永続的に拒否されました。アプリの設定で有効にしてください。';

  @override
  String get cameraPermissionTitle => 'カメラ権限';

  @override
  String get cameraPermissionMessage => 'このアプリは写真を撮るためにカメラへのアクセスが必要です。';

  @override
  String get cameraPermissionSettings => 'カメラ権限が永続的に拒否されています。この機能を使用するには設定で有効にしてください。';

  @override
  String get storagePermissionTitle => 'ストレージ権限';

  @override
  String get storagePermissionMessage => 'このアプリはファイルを保存するためにストレージへのアクセスが必要です。';

  @override
  String get storagePermissionSettings => 'ストレージ権限が永続的に拒否されています。設定で有効にしてください。';

  @override
  String get locationPermissionTitle => '位置情報権限';

  @override
  String get locationPermissionMessage => 'このアプリは近くの場所を表示するために位置情報へのアクセスが必要です。';

  @override
  String get locationPermissionSettings => '位置情報権限が永続的に拒否されています。設定で有効にしてください。';

  @override
  String get notificationPermissionTitle => '通知権限';

  @override
  String get notificationPermissionMessage => 'このアプリは更新情報を送信するために通知権限が必要です。';

  @override
  String get notificationPermissionSettings => '通知権限が永続的に拒否されています。設定で有効にしてください。';
}
