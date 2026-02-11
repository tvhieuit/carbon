import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../use_case/get_locale_use_case.dart';
import '../use_case/get_theme_mode_use_case.dart';
import '../use_case/set_locale_use_case.dart';
import '../use_case/set_theme_mode_use_case.dart';

part 'app_settings_bloc.freezed.dart';
part 'app_settings_event.dart';
part 'app_settings_state.dart';

@injectable
class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  final GetThemeModeUseCase _getThemeModeUseCase;
  final SetThemeModeUseCase _setThemeModeUseCase;
  final GetLocaleUseCase _getLocaleUseCase;
  final SetLocaleUseCase _setLocaleUseCase;

  AppSettingsBloc(
    this._getThemeModeUseCase,
    this._setThemeModeUseCase,
    this._getLocaleUseCase,
    this._setLocaleUseCase,
  ) : super(AppSettingsState.initial()) {
    on(_onStarted);
    on(_onThemeModeChanged);
    on(_onLocaleChanged);

    add(const AppSettingsEvent.started());
  }

  Future<void> _onStarted(_Started event, emit) async {
    final themeModeResult = await _getThemeModeUseCase();
    final themeMode = themeModeResult.dataOrNull;

    //todo default ja locale
    // final localeResult = await _getLocaleUseCase();
    // final locale = localeResult.dataOrNull;

    emit(
      state.copyWith(
        themeMode: themeMode ?? ThemeMode.system,
        locale: const Locale('ja'),
      ),
    );
  }

  Future<void> _onThemeModeChanged(_ThemeModeChanged event, emit) async {
    emit(state.copyWith(themeMode: event.themeMode));
    await _setThemeModeUseCase(event.themeMode);
  }

  Future<void> _onLocaleChanged(_LocaleChanged event, emit) async {
    emit(state.copyWith(locale: event.locale));
    await _setLocaleUseCase(event.locale);
  }
}
