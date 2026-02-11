part of 'login_bloc.dart';

/// Events for Login screen
@eventFreezed
sealed class LoginEvent with _$LoginEvent {
  const factory LoginEvent.started() = _LoginEventStarted;

  /// Event to submit login credentials
  const factory LoginEvent.submit({
    required String email,
    required String password,
  }) = LoginEventSubmit;

  const factory LoginEvent.register() = _LoginEventRegister;
  const factory LoginEvent.forgotPassword() = _LoginEventForgotPassword;
  const factory LoginEvent.obscurePasswordToggle() = _LoginEventObscurePasswordToggle;
}
