import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:shop/firebase_options.dart';
import 'package:shop/src/config/app_config.dart';
import 'package:shop/src/config/app_contants.dart';
import 'package:shop/src/config/global_key_constants.dart';
import 'package:shop/src/providers.dart';
import 'package:shop/src/services/hive_service.dart';
import 'package:shop/src/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'src/route/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialize();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Firebase App Check
  if (kReleaseMode) {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity, // For Android
      appleProvider: AppleProvider.appAttestWithDeviceCheckFallback, // For iOS
    );
  } else {
    // In debug mode, you can use the debug provider
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug,
    );
  }

  await dotenv.load(fileName: ".env");

  GoRouter.optionURLReflectsImperativeAPIs = true;

  await Hive.initFlutter();

  await Hive.openBox("app");

  await HiveService().init();

  final appConfig = AppConfig();

  await appConfig.initialize();

  runApp(ChangeNotifierProvider.value(
    value: appConfig,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: LayoutBuilder(builder: (context, constraints) {
        final GoRouter goRouter =
            Provider.of<AppRouter>(context, listen: false).router;
        return FractionallySizedBox(
          widthFactor: constraints.maxWidth > 1024 ? .5 : 1,
          child: MaterialApp.router(
            localizationsDelegates: [
              CountryLocalizations.getDelegate(enableLocalization: false),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            title: AppContants().appName,
            theme: AppTheme.lightTheme(context),
            themeMode: ThemeMode.light,
            routerConfig: goRouter,
            scaffoldMessengerKey: GlobalKeyContants().scaffoldMessengerKey,
          ),
        );
      }),
    );
  }
}
