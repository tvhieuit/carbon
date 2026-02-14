import 'package:feature_app_settings/app_settings.dart';
import 'package:feature_auth/auth.dart';
import 'package:feature_dashboard/feature_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/di/injection.dart';
import 'package:get_it/get_it.dart';
import 'package:feature_qr_scan/feature_qr_scan.dart';

import '../l10n/app_localization.dart';
import 'app_router.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = getIt<AppRouter>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<AppSettingsBloc>(),
      child: BlocBuilder<AppSettingsBloc, AppSettingsState>(
        buildWhen: (previous, current) => previous.themeMode != current.themeMode || previous.locale != current.locale,
        builder: (context, state) {
          return GestureDetector( // todo review late,
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: MaterialApp.router(
              onGenerateTitle: (context) => AppLocalizations.of(context).appName,
              scaffoldMessengerKey: GetIt.instance(),
              debugShowCheckedModeBanner: false,
              locale: state.locale,
              localizationsDelegates: const {
                ...AppLocalizations.localizationsDelegates,
                AuthLocalizationsFallback.delegate,
                AppSettingsLocalizations.delegate,
                DashboardLocalizations.delegate,
                QrScanLocalizations.delegate,
              },
              supportedLocales: AppLocalizations.supportedLocales,
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.blue,
                  brightness: Brightness.dark,
                ),
              ),
              themeMode: state.themeMode,
              routerConfig: _appRouter.config(),
            ),
          );
        },
      ),
    );
  }
}
