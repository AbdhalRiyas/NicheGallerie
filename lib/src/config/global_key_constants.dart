import 'package:flutter/material.dart';

class GlobalKeyContants {
  GlobalKeyContants._internal();
  static final _instance = GlobalKeyContants._internal();
  factory GlobalKeyContants() => _instance;

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
