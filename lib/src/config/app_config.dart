import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/services/api_service.dart';

class AppConfig with ChangeNotifier {
  Map<String, dynamic>? _config;
  Map<String, dynamic>? _preferredCurrency;

  Map<String, dynamic>? get config => _config;

  String get helpLink =>
      _config?['help_link'] ?? 'https://nichegallerie.com/contact/';

  String get faqLink =>
      _config?['faq_link'] ?? 'https://nichegallerie.com/faq/';

  Map<String, String> get socialMedia =>
      Map<String, String>.from(_config?['social_media'] ?? {});

  List<Map<String, dynamic>> get paymentMethods =>
      List<Map<String, dynamic>>.from(_config?['payment_methods'] ?? []);

  List<Map<String, dynamic>> get currencies =>
      List<Map<String, dynamic>>.from(_config?['currencies'] ??
          [
            {
              "code": "AED",
              "name": "Arab Emirates Dirham",
              "symbol": "AED",
            }
          ]);

  Map<dynamic, dynamic> get preferredCurrency =>
      _preferredCurrency ?? currencies.first;

  Future<void> initialize() async {
    // Load cached config
    final cachedConfig = await _loadCachedConfig();
    if (cachedConfig != null) {
      _config = cachedConfig;
      notifyListeners(); // Notify listeners that the config has been updated
    }

    // Load preferred currency
    _preferredCurrency =
        getJSONAsync('preferred_currency', defaultValue: currencies.first);

    // Fetch fresh config from the API
    try {
      final freshConfig = await _fetchConfig();
      _config = freshConfig;
      await _saveConfig(freshConfig); // Cache the fresh config
      notifyListeners(); // Notify listeners that the config has been updated
    } catch (e) {
      log(e.toString());
    }
  }

  Future<Map<String, dynamic>> _fetchConfig() async {
    final response = await ApiService().get(ApiContants().config);
    return response;
  }

  Future<void> _saveConfig(Map<String, dynamic> config) async {
    await setValue('app_config', json.encode(config));
  }

  Future<Map<String, dynamic>?> _loadCachedConfig() async {
    final configString = getStringAsync('app_config');
    if (configString != '') {
      return json.decode(configString);
    }
    return null;
  }

  Future<void> setPreferredCurrency(Map<String, dynamic> currency) async {
    _preferredCurrency = currency;
    await setValue('preferred_currency', _preferredCurrency);
    notifyListeners(); // Notify listeners that the preferred currency has been updated
  }
}
