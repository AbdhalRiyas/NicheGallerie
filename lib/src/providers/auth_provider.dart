import 'package:flutter/foundation.dart';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/services/api_service.dart';
import 'package:shop/src/services/hive_service.dart';

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

  AuthProvider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    try {
      final authData = await HiveService().getAuth();
      if (authData != null && authData['token'] != null) {
        _token = authData['token'];
        _userEmail = authData['user_email'];
        _userDisplayName = authData['user_display_name'];
        _userNicename = authData['user_nicename'];
        _isLoggedIn = true;
      } else {
        _isLoggedIn = false;
      }
    } catch (e) {
      _isLoggedIn = false;
    } finally {
      notifyListeners();
    }
  }

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
      await HiveService().saveAuth(res);
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
    HiveService().clearAuth();
    notifyListeners();
  }
}
