import 'package:hive/hive.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();

  factory HiveService() => _instance;

  HiveService._internal();

  late Box _appBox;

  Future<void> init() async {
    _appBox = Hive.box("app");
  }

  Future<void> saveAuth(Map<dynamic, dynamic> jwt) async {
    await _appBox.put(
      'auth',
      jwt,
    );
  }

  Future<Map<dynamic, dynamic>?> getAuth() async {
    return _appBox.get('auth');
  }

  Future<void> clearAuth() async {
    await _appBox.delete('auth');
  }
}
