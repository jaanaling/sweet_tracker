import 'package:candy_planner/src/core/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/feature/app/presentation/app_root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencyInjection();

  // await Firebase.initializeApp();

  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    const AppRoot(),
  );
}
