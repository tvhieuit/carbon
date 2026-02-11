import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_token.freezed.dart';
part 'auth_token.g.dart';

/// Authentication token response
@modelFreezed
sealed class AuthToken with _$AuthToken {
  const AuthToken._();

  const factory AuthToken({
    required String id,
    required String email,
    @JsonKey(name: 'user_type') required String userType,
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') String? refreshToken,
    String? expiration,
    @JsonKey(name: 'is_admin') @Default(false) bool isAdmin,
    @JsonKey(name: 'token_type') @Default('Bearer') String tokenType,
  }) = _AuthToken;

  factory AuthToken.fromJson(Map<String, dynamic> json) => _$AuthTokenFromJson(json);

  /// Checks if token is expired
  bool get isExpired {
    if (expiration == null) return false;
    try {
      final expiryTime = DateTime.parse(expiration!);
      return DateTime.now().isAfter(expiryTime);
    } catch (_) {
      return false;
    }
  }

  /// Gets the authorization header value
  String get authorizationHeader => '$tokenType $accessToken';
}
