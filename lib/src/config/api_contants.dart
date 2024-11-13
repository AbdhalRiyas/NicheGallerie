class ApiContants {
  ApiContants._internal();
  static final _instance = ApiContants._internal();
  factory ApiContants() => _instance;

  final String products = '/products';
}
