import 'package:app_core/app_core.dart';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

/// Implementation of AuthRepository using Dio for API calls.
@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  final LocalStorage _localStorage;

  AuthRepositoryImpl(@authDioNamed this._dio, this._localStorage);

  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';

  @override
  Future<Result<AuthToken>> login(LoginCredentials credentials) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'username': credentials.email,
          'password': credentials.password,
        },
      );

      final token = AuthToken.fromJson(response.data);
      await _saveTokens(token);
      return Result.success(token);
    } on DioException catch (e) {
      return Result.failure(_handleDioError(e));
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<AuthToken>> register(RegisterCredentials credentials) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {
          'name': credentials.name,
          'email': credentials.email,
          'password': credentials.password,
          'phone': credentials.phone,
        },
      );

      final token = AuthToken.fromJson(response.data);
      await _saveTokens(token);
      return Result.success(token);
    } on DioException catch (e) {
      return Result.failure(_handleDioError(e));
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      // Optional: Call API logout endpoint
      // await _dio.post('/auth/logout');

      // Clear local tokens
      await _clearTokens();
      return const Result.success(null);
    } catch (e) {
      // Always clear local data even if API fails
      await _clearTokens();
      return const Result.success(null);
    }
  }

  @override
  Future<Result<AuthToken>> refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final token = AuthToken.fromJson(response.data);
      await _saveTokens(token);
      return Result.success(token);
    } on DioException catch (e) {
      return Result.failure(_handleDioError(e));
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<bool>> isAuthenticated() async {
    try {
      final token = await _localStorage.getString(_tokenKey);
      return Result.success(token != null && token.isNotEmpty);
    } catch (e) {
      return const Result.success(false);
    }
  }

  @override
  Future<Result<String?>> getAccessToken() async {
    try {
      final token = await _localStorage.getString(_tokenKey);
      return Result.success(token);
    } catch (e) {
      return Result.failure(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> forgotPassword(String email) async {
    try {
      await _dio.post(
        '/auth/forgot-password',
        data: {'email': email},
      );
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(_handleDioError(e));
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _dio.post(
        '/auth/reset-password',
        data: {
          'token': token,
          'password': newPassword,
        },
      );
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(_handleDioError(e));
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> verifyEmail(String otp) async {
    try {
      await _dio.post(
        '/auth/verify-email',
        data: {'otp': otp},
      );
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(_handleDioError(e));
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> resendVerificationEmail(String email) async {
    try {
      await _dio.post(
        '/auth/resend-verification',
        data: {'email': email},
      );
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(_handleDioError(e));
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  // Helper methods

  Future<void> _saveTokens(AuthToken token) async {
    await _localStorage.setString(_tokenKey, token.accessToken);
    if (token.refreshToken != null) {
      await _localStorage.setString(_refreshTokenKey, token.refreshToken!);
    }
  }

  Future<void> _clearTokens() async {
    await _localStorage.remove(_tokenKey);
    await _localStorage.remove(_refreshTokenKey);
  }

  Failure _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const Failure.network(message: 'Connection timeout');
      case DioExceptionType.connectionError:
        return const Failure.network(message: 'No internet connection');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        final message = _extractErrorMessage(e.response?.data);
        if (statusCode == 401) {
          return Failure.auth(message: message, code: 'UNAUTHORIZED');
        } else if (statusCode == 403) {
          return Failure.auth(message: message, code: 'FORBIDDEN');
        } else if (statusCode == 404) {
          return Failure.server(message: message, code: 'NOT_FOUND', statusCode: statusCode);
        } else if (statusCode >= 500) {
          return Failure.server(message: message, statusCode: statusCode);
        }
        return Failure.server(message: message, statusCode: statusCode);
      default:
        return Failure.unknown(message: e.message ?? 'Unknown error');
    }
  }

  String _extractErrorMessage(dynamic data) {
    if (data == null) return 'An error occurred';
    if (data is Map) {
      return data['message'] ?? data['error'] ?? 'An error occurred';
    }
    return data.toString();
  }
}
