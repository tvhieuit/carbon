import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../storage/storage_keys.dart';

/// Implementation of [UserLocalRepository] using [LocalStorage].
@LazySingleton(as: UserLocalRepository)
class UserLocalRepositoryImpl implements UserLocalRepository {
  final LocalStorage _storage;

  UserLocalRepositoryImpl(this._storage);

  @override
  Future<Result<UserEntity?>> getCurrentUser() async {
    try {
      final json = await _storage.getJson(StorageKeys.currentUser);
      if (json == null) return const Result.success(null);
      return Result.success(UserEntity.fromJson(json));
    } catch (e) {
      return Result.failure(Failure.cache(message: 'Failed to get current user: $e'));
    }
  }

  @override
  Future<Result<void>> saveCurrentUser(UserEntity user) async {
    try {
      await _storage.setJson(StorageKeys.currentUser, user.toJson());
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.cache(message: 'Failed to save current user: $e'));
    }
  }

  @override
  Future<Result<void>> clearCurrentUser() async {
    try {
      await _storage.remove(StorageKeys.currentUser);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.cache(message: 'Failed to clear current user: $e'));
    }
  }

  @override
  Future<Result<List<UserEntity>>> getCachedUsers() async {
    try {
      final jsonList = await _storage.getJsonList(StorageKeys.cachedUsers);
      if (jsonList == null || jsonList.isEmpty) return const Result.success([]);
      final users = jsonList.map((json) => UserEntity.fromJson(json)).toList();
      return Result.success(users);
    } catch (e) {
      return Result.failure(Failure.cache(message: 'Failed to get cached users: $e'));
    }
  }

  @override
  Future<Result<void>> cacheUsers(List<UserEntity> users) async {
    try {
      final jsonList = users.map((user) => user.toJson()).toList();
      await _storage.setJsonList(StorageKeys.cachedUsers, jsonList);
      await _storage.setInt(
        StorageKeys.usersCacheTimestamp,
        DateTime.now().millisecondsSinceEpoch,
      );
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.cache(message: 'Failed to cache users: $e'));
    }
  }

  @override
  Future<Result<void>> clearCachedUsers() async {
    try {
      await _storage.remove(StorageKeys.cachedUsers);
      await _storage.remove(StorageKeys.usersCacheTimestamp);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.cache(message: 'Failed to clear cached users: $e'));
    }
  }

  @override
  Future<bool> isUsersCacheValid({Duration maxAge = const Duration(hours: 1)}) async {
    try {
      final timestamp = await _storage.getInt(StorageKeys.usersCacheTimestamp);
      if (timestamp == null) return false;
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return DateTime.now().difference(cacheTime) < maxAge;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Result<String?>> getAccessToken() async {
    try {
      final token = await _storage.getString(StorageKeys.accessToken);
      return Result.success(token);
    } catch (e) {
      return Result.failure(Failure.cache(message: 'Failed to get access token: $e'));
    }
  }

  @override
  Future<Result<void>> saveAccessToken(String token) async {
    try {
      await _storage.setString(StorageKeys.accessToken, token);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.cache(message: 'Failed to save access token: $e'));
    }
  }

  @override
  Future<Result<void>> clearAccessToken() async {
    try {
      await _storage.remove(StorageKeys.accessToken);
      await _storage.remove(StorageKeys.refreshToken);
      await _storage.remove(StorageKeys.tokenExpiry);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.cache(message: 'Failed to clear access token: $e'));
    }
  }

  @override
  Future<Result<void>> clearAllUserData() async {
    try {
      await clearCurrentUser();
      await clearCachedUsers();
      await clearAccessToken();
      await _storage.remove(StorageKeys.userPreferences);
      await _storage.remove(StorageKeys.userId);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.cache(message: 'Failed to clear all user data: $e'));
    }
  }

  @override
  Future<Result<List<String>>> getEmailHistory() async {
    try {
      final history = await _storage.getStringList(StorageKeys.emailHistory);
      return Result.success(history ?? []);
    } catch (e) {
      return Result.failure(Failure.cache(message: 'Failed to get email history: $e'));
    }
  }

  @override
  Future<Result<void>> saveEmailToHistory(String email) async {
    try {
      final history = (await _storage.getStringList(StorageKeys.emailHistory)) ?? [];
      if (!history.contains(email)) {
        history.insert(0, email);
        // Keep only top 10
        if (history.length > 10) {
          history.removeRange(10, history.length);
        }
        await _storage.setStringList(StorageKeys.emailHistory, history);
      } else {
        // Move to top if already exists
        history.remove(email);
        history.insert(0, email);
        await _storage.setStringList(StorageKeys.emailHistory, history);
      }
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.cache(message: 'Failed to save email to history: $e'));
    }
  }
}
