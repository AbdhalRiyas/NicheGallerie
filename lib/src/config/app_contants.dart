import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppContants {
  AppContants._internal();
  static final _instance = AppContants._internal();
  factory AppContants() => _instance;

  String get appName => dotenv.env['APP_NAME'] ?? "Witcommerce";

  String get apiBaseUrl =>
      dotenv.env['API_URL'] ?? "https://niche.witsberry.com/api/v3";
}
