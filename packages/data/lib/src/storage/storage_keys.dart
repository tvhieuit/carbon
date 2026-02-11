/// Storage keys constants for type-safe key access.
abstract class StorageKeys {
  StorageKeys._();

  // AUTH
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String tokenExpiry = 'token_expiry';

  // USER
  static const String currentUser = 'current_user';
  static const String userId = 'user_id';
  static const String userPreferences = 'user_preferences';
  static const String emailHistory = 'email_history';

  // APP SETTINGS
  static const String themeMode = 'theme_mode';
  static const String languageCode = 'language_code';
  static const String isFirstLaunch = 'is_first_launch';
  static const String onboardingCompleted = 'onboarding_completed';

  // CACHE
  static const String cachedUsers = 'cached_users';
  static const String cachedProducts = 'cached_products';
  static const String usersCacheTimestamp = 'users_cache_timestamp';
  static const String productsCacheTimestamp = 'products_cache_timestamp';

  // NOTIFICATIONS
  static const String pushNotificationEnabled = 'push_notification_enabled';
  static const String fcmToken = 'fcm_token';

  // HELPERS
  static String cacheKey(String key) => 'cache_$key';
  static String timestampKey(String key) => '${key}_timestamp';
}
