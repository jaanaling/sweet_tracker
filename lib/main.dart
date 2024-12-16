import 'dart:async';

import 'package:core_logic/core_logic.dart';
import 'package:core_amplitude/core_amplitude.dart';
import 'package:sweet_planner/src/core/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/feature/app/presentation/app_root.dart';

void main() async {
  runZonedGuarded(() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      _handleFlutterError(details);
    };
    WidgetsFlutterBinding.ensureInitialized();
    setupDependencyInjection();

    await InitializationUtil.coreInit(
      domain: 'sweetplannera.com',
      amplitudeKey: 'b0503876cde6acd9c9ac7435f9d101d6',
      appsflyerDevKey: 'MtsSRcsCnfTkHoXwCRUea9',
      appId: 'com.amberglade.sweetplanner',
      iosAppId: '6739362355',
      initialRoute: '/home',
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    runApp(
      const AppRoot(),
    );
  }, (Object error, StackTrace stackTrace) {
    _handleAsyncError(error, stackTrace);
  });
}

void _handleFlutterError(FlutterErrorDetails details) {
  AmplitudeUtil.logFailure(
    details.exception is Exception ? Failure.exception : Failure.error,
    details.exception.toString(),
    details.stack,
  );
}

void _handleAsyncError(Object error, StackTrace stackTrace) {
  AmplitudeUtil.logFailure(
    error is Exception ? Failure.exception : Failure.error,
    error.toString(),
    stackTrace,
  );
}
