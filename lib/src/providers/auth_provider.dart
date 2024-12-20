import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/config/global_key_constants.dart';
import 'package:shop/src/services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _token;
  String? _userEmail;
  String? _userDisplayName;
  String? _userNicename;

  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;
  String? get email => _userEmail;
  String? get displayName => _userDisplayName;
  String? get nicename => _userNicename;

  Future<bool> login(String username, String password) async {
    try {
      final res = await ApiService().post(ApiContants().login, payload: {
        'username': username,
        'password': password,
      });

      _token = res['token'];
      _userEmail = res['user_email'];
      _userDisplayName = res['user_display_name'];
      _userNicename = res['user_nicename'];
      _isLoggedIn = true;
      print(res);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  void logout() {
    _token = null;
    _isLoggedIn = false;
    _userEmail = null;
    _userDisplayName = null;
    _userNicename = null;
    notifyListeners(); // Notify widgets to rebuild
  }

  // Future<void> checkAuthStatus() async {
  //   // Check if the user is already logged in by validating the stored token
  //   try {
  //     final isValid = await validateToken(_token);
  //     _isLoggedIn = isValid;
  //     notifyListeners(); // Notify widgets to rebuild
  //   } catch (error) {
  //     _isLoggedIn = false;
  //     notifyListeners();
  //   }
  // }
}
