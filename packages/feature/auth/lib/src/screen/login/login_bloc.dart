import 'package:app_core/app_core.dart';
import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:app_widget/app_widget.dart';

import '../../navigation/auth_navigation.dart';
import '../../use_case/use_cases.dart';

part 'login_bloc.freezed.dart';

part 'login_event.dart';

part 'login_state.dart';

/// BLoC for managing login screen state
@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;
  final UserLocalRepository _userLocalRepository;
  final StackRouter _router;
  final AppRoute _appRoute;
  final AppToast _toast;

  LoginBloc(
    this._loginUseCase,
    this._userLocalRepository,
    this._router,
    this._appRoute,
    this._toast,
  ) : super(LoginState.initial()) {
    on(_onStarted);
    on(_onLogin);
    on(_onRegister);
    on(_onForgotPassword);
    on(_onObscurePasswordToggle);

    add(const LoginEvent.started());
  }

  Future<void> _onStarted(_LoginEventStarted event, emit) async {
    final result = await _userLocalRepository.getEmailHistory();
    if (result.isSuccess) {
      emit(state.copyWith(emailHistory: result.dataOrThrow));
    }
  }

  /// Handles login event
  Future<void> _onLogin(LoginEventSubmit event, emit) async {
    emit(state.copyWith(isLoading: true, error: null, fieldError: null));
    try {
      final credentials = LoginCredentials(
        email: event.email,
        password: event.password,
      );
      final result = await _loginUseCase(credentials);
      assert(result.isFailure, result.failureOrNull);
      final token = result.dataOrThrow;

      // Save email to history
      await _userLocalRepository.saveEmailToHistory(event.email);

      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: true,
          token: token,
          error: null,
          fieldError: null,
        ),
      );
      _router.replaceAll([_appRoute.home]);
    } on Failure catch (e) {
      emit(state.copyWith(isLoading: false, error: e.message));
      _toast.show(e.message, type: AppToastType.error);
    } catch (e) {

      emit(state.copyWith(isLoading: false, error: 'An unexpected error occurred'));
      _toast.show('An unexpected error occurred', type: AppToastType.error);
      rethrow;
    }
  }

  Future<void> _onRegister(_LoginEventRegister event, emit) async {
    _router.push(_appRoute.register);
  }

  Future<void> _onForgotPassword(_LoginEventForgotPassword event, emit) async {
    // TODO: Add forgot password route to AppRoute
  }

  Future<void> _onObscurePasswordToggle(
    _LoginEventObscurePasswordToggle event,
    emit,
  ) async {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }
}
