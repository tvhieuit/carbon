import '../../entities/user_entity.dart';
import 'package:app_core/app_core.dart';

/// Local repository interface for user data caching.
abstract class UserLocalRepository {
  /// Gets the current cached user
  Future<Result<UserEntity?>> getCurrentUser();

  /// Saves the current user to cache
  Future<Result<void>> saveCurrentUser(UserEntity user);

  /// Clears the current user from cache
  Future<Result<void>> clearCurrentUser();

  /// Gets cached user list
  Future<Result<List<UserEntity>>> getCachedUsers();

  /// Saves user list to cache
  Future<Result<void>> cacheUsers(List<UserEntity> users);

  /// Clears cached user list
  Future<Result<void>> clearCachedUsers();

  /// Checks if user cache is valid (not expired)
  Future<bool> isUsersCacheValid({Duration maxAge = const Duration(hours: 1)});

  /// Gets access token
  Future<Result<String?>> getAccessToken();

  /// Saves access token
  Future<Result<void>> saveAccessToken(String token);

  /// Clears access token
  Future<Result<void>> clearAccessToken();

  /// Clears all user-related data (logout)
  Future<Result<void>> clearAllUserData();

  /// Gets email history from cache
  Future<Result<List<String>>> getEmailHistory();

  /// Saves email to history cache
  Future<Result<void>> saveEmailToHistory(String email);
}
