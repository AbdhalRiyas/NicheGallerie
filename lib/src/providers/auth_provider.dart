import 'dart:developer';
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
      if (authData != null) {
        await _setUserData(authData);
        final res = await ApiService().post(ApiContants().validate, payload: {
          '_token': authData['data']['token'],
        });

        log(res.toString());

        if (res['success'] == true) {
          await _setUserData(res);
        }
      } else {
        _isLoggedIn = false;
      }
    } catch (e) {
      _isLoggedIn = false;
      log('Error initializing auth: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> _setUserData(Map<dynamic, dynamic> data) async {
    _token = data['data']['token'];
    _userEmail = data['data']['user']['user_email'];
    _userDisplayName = data['data']['user']['display_name'];
    _userNicename = data['data']['user']['user_nicename'];
    _isLoggedIn = true;
    await HiveService().saveAuth(data);
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    try {
      final res = await ApiService().post(ApiContants().login, payload: {
        'username': username,
        'password': password,
      });

      if (res['success'] == true) {
        log(res.toString());
        await _setUserData(res);
        return true;
      }

      await HiveService().clearAuth();
      return false;
    } catch (e) {
      log('Login error: $e');
      return false;
    }
  }

  Future<bool> register(String email, String password, String phoneNumber,
      String dateOfBirth) async {
    try {
      final res = await ApiService().post(ApiContants().register, payload: {
        'email': email,
        'password': password,
        'date_of_birth': dateOfBirth,
        'phone_number': phoneNumber,
      });

      if (res['success'] == true) {
        log(res.toString());
        await _setUserData(res);
        return true;
      }
      return false;
    } catch (e) {
      log('Register error: $e');
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
