import 'package:app_core/app_core.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Data layer dependency injection module.
@module
abstract class DataModule {
  /// Provides SharedPreferencesAsync instance.
  @lazySingleton
  SharedPreferencesAsync get sharedPreferencesAsync => SharedPreferencesAsync();

  /// Main Dio instance with auth interceptor
  @lazySingleton
  Dio dio(
    @authInterceptorNamed Interceptor authInterceptor,
    @apiUrlNamed String apiUrl,
  ) {
    final dio = Dio(
      BaseOptions(
        baseUrl: apiUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-user-type': 'STAFF',
        },
      ),
    );
    dio.interceptors.addAll([
      authInterceptor,
      LogInterceptor(responseBody: true, requestBody: true),
    ]);
    return dio;
  }

  /// Dio instance specifically for AuthRepository to avoid circular dependency
  @authDioNamed
  @lazySingleton
  Dio authDio(@apiUrlNamed String apiUrl) {
    return Dio(
      BaseOptions(
        baseUrl: apiUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-user-type': 'STAFF',
        },
      ),
    );
  }
}
