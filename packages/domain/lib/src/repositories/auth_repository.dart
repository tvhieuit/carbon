import 'package:app_core/app_core.dart';
import '../entities/auth/auth_credentials.dart';
import '../entities/auth/auth_token.dart';
import '../entities/auth/me_entity.dart';

/// Authentication repository interface.
///
/// Defines the contract for authentication operations.
/// Implementation should handle API calls and token storage.
abstract class AuthRepository {
  /// Logs in with email and password.
  ///
  /// Returns [AuthToken] on success.
  Future<Result<AuthToken>> login(LoginCredentials credentials);

  /// Gets the current authenticated user's information.
  Future<Result<MeEntity>> getMe();

  /// Registers a new user.
  ///
  /// Returns [AuthToken] on success (auto-login after register).
  Future<Result<AuthToken>> register(RegisterCredentials credentials);

  /// Logs out the current user.
  ///
  /// Should clear tokens and user data.
  Future<Result<void>> logout();

  /// Refreshes the access token using refresh token.
  Future<Result<AuthToken>> refreshToken(String refreshToken);

  /// Checks if user is currently authenticated.
  ///
  /// Returns true if valid token exists.
  Future<Result<bool>> isAuthenticated();

  /// Gets the current access token.
  Future<Result<String?>> getAccessToken();

  /// Sends password reset email.
  Future<Result<void>> forgotPassword(String email);

  /// Resets password with token.
  Future<Result<void>> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Verifies email with OTP.
  Future<Result<void>> verifyEmail(String otp);

  /// Resends email verification OTP.
  Future<Result<void>> resendVerificationEmail(String email);
}
