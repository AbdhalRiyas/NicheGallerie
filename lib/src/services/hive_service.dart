import 'package:hive/hive.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();

  factory HiveService() => _instance;

  HiveService._internal();

  late Box _appBox;

  Future<void> init() async {
    _appBox = Hive.box("app");
  }
}
