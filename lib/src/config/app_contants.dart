class AppContants {
  AppContants._internal();
  static final _instance = AppContants._internal();
  factory AppContants() => _instance;

  final String appName = 'Cryptala';

  final String apiBaseUrl = "http://witcommerce-cp.test/api/v3";
}
