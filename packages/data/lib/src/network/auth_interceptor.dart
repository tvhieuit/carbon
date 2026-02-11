import 'package:app_core/app_core.dart';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

/// Interceptor to handle authentication headers and automated token refresh.
@authInterceptorNamed
@Injectable(as: Interceptor)
class AuthInterceptor extends Interceptor {
  final AuthRepository _authRepository;

  AuthInterceptor(this._authRepository);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final result = await _authRepository.getAccessToken();
    final token = result.data;

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    options.headers['x-user-type'] = 'STAFF';
    options.headers['Accept-Language'] = 'ja-JP';
    options.headers['x-provider'] = '';

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Logic for token refresh can be implemented here if needed,
      // but usually it's better to handle it in a way that doesn't
      // cause circular dependencies. For now, we'll just pass the error.
    }

    handler.next(err);
  }
}
