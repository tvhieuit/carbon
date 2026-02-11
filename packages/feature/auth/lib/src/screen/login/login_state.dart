part of 'login_bloc.dart';

/// State for Login screen
@stateFreezed
sealed class LoginState with _$LoginState {
  const LoginState._();

  const factory LoginState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    @Default(true) bool obscurePassword,
    AuthToken? token,
    @Default([]) List<String> emailHistory,
    String? error,
    String? fieldError,
  }) = _LoginState;

  factory LoginState.initial() => const LoginState();
}
