import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/config/app_contants.dart';
import 'package:shop/src/providers.dart';
import 'package:shop/src/route/route_constants.dart';
import 'package:shop/src/route/router.dart' as router;
import 'package:shop/src/theme/app_theme.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  GoRouter.optionURLReflectsImperativeAPIs = true;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Builder(builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppContants().appName,
          theme: AppTheme.lightTheme(context),
          themeMode: ThemeMode.light,
          onGenerateRoute: router.generateRoute,
          initialRoute: onbordingScreenRoute,
        );
      }),
    );
  }
}
