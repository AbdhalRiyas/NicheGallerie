import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppContants {
  AppContants._internal();
  static final _instance = AppContants._internal();
  factory AppContants() => _instance;

  String get appName => dotenv.env['APP_NAME'] ?? "Witcommerce";

  String get apiBaseUrl => kReleaseMode
      ? dotenv.env['PROD_URL'] ?? "https://niche.witsberry.com/api/v3"
      : dotenv.env['API_URL'] ?? "http://192.168.56.1:8000/api/v3";
}
