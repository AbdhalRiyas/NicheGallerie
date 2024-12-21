import 'package:hive/hive.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();

  factory HiveService() => _instance;

  HiveService._internal();

  late Box _appBox;

  Future<void> init() async {
    _appBox = Hive.box("app");
  }

  bool getOnboardSkipped() {
    return _appBox.get("onboard_skipped", defaultValue: false);
  }

  void setOnboardSkipped(bool value) {
    _appBox.put("onboard_skipped", value);
  }
}
