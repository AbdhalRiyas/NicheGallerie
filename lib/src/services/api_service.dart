import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shop/src/config/app_contants.dart';
import 'package:shop/src/config/global_key_constants.dart';
import 'package:shop/src/error/app_exception.dart';
import 'package:shop/src/providers/auth_provider.dart';

class ApiService {
  ApiService._internal();
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  Future<dynamic> get(String apiEndPoint) async {
    final Uri uri = Uri.parse("${AppContants().apiBaseUrl}$apiEndPoint");

    try {
      final headers = await _buildHeaders();
      final res = await http
          .get(
            uri,
            headers: headers,
          )
          .timeout(const Duration(seconds: 30));

      log("API Response: ${res.body}");

      return _processResponse(res);
    } on SocketException {
      throw FetchDataException("No Internet Connection", uri.toString());
    } on TimeoutException {
      throw ServerNotRespondException(
          "Couldn't able to connect with server on time.", uri.toString());
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> post(
    String apiEndPoint, {
    Map<dynamic, dynamic>? payload,
  }) async {
    final Uri uri = Uri.parse("${AppContants().apiBaseUrl}$apiEndPoint");

    try {
      final headers = await _buildHeaders();
      final res = await http
          .post(
            uri,
            headers: headers,
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 30));
      log("API Response: ${res.body}");
      return _processResponse(res);
    } on SocketException {
      throw FetchDataException("No Internet Connection", uri.toString());
    } on TimeoutException {
      throw ServerNotRespondException("Server request timeout", uri.toString());
    }
  }

  Future<dynamic> put(String apiEndPoint,
      {Map<dynamic, dynamic>? payload}) async {
    final Uri uri = Uri.parse("${AppContants().apiBaseUrl}$apiEndPoint");

    try {
      final headers = await _buildHeaders();
      final res = await http
          .put(
            uri,
            headers: headers,
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 20));

      return _processResponse(res);
    } on SocketException {
      throw FetchDataException("No Internet Connection", uri.toString());
    } on TimeoutException {
      throw ServerNotRespondException("Server request timeout", uri.toString());
    }
  }

  Future<dynamic> delete(String apiEndPoint,
      {Map<dynamic, dynamic>? payload, bool wooCommerce = true}) async {
    final Uri uri = Uri.parse("${AppContants().apiBaseUrl}$apiEndPoint");

    try {
      final headers = await _buildHeaders();
      final res = await http
          .delete(
            uri,
            headers: headers,
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 15));

      return _processResponse(res);
    } on SocketException {
      throw FetchDataException("No Internet Connection", uri.toString());
    } on TimeoutException {
      throw ServerNotRespondException("Server request timeout", uri.toString());
    }
  }

  dynamic _processResponse(http.Response response) {
    var responseJson = json.decode(utf8.decode(response.bodyBytes));

    switch (response.statusCode) {
      case 200:
        return responseJson;

      case 202:
        var res = responseJson;
        res['status'] = response.statusCode;
        return responseJson;

      case 400:
        throw BadRequestException(
          response.request!.url.toString(),
        );

      case 401:
        throw UnauthorizedException(
          responseJson["message"],
          response.request!.url.toString(),
        );

      case 403:
      case 422:
        throw RequiredParamterException(
          responseJson['message'],
          response.request!.url.toString(),
        );
      case 429:
        throw UnauthorizedException(
          responseJson["message"],
          response.request!.url.toString(),
        );

      case 500:
        throw ServerNotRespondException(
          'error_occured_with_code : ${response.statusCode}',
          response.request!.url.toString(),
        );
      case 503:
        throw ServerNotRespondException(
          'error_occured_with_code: ${response.statusCode}',
          response.request!.url.toString(),
        );
      default:
        throw ServerNotRespondException(
          'error_occured_with_code: ${response.statusCode}',
          response.request!.url.toString(),
        );
    }
  }

  Future<Map<String, String>> _buildHeaders() async {
    final headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Connection": "Keep-Alive",
    };

    // Add Authorization token if available
    final context = GlobalKeyContants().navigatorKey.currentContext;
    if (context != null) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.token != null) {
        headers["Authorization"] = "Bearer ${authProvider.token}";
      }
    }

    // Add Firebase App Check token
    try {
      final appCheckToken = await FirebaseAppCheck.instance.getToken();
      if (appCheckToken != null) {
        headers["X-Firebase-AppCheck"] = appCheckToken;
        log("App Check Token: $appCheckToken");
      } else {
        log("App Check Token is null. Ensure debug provider is configured for emulator.");
      }
    } catch (e) {
      log("Error fetching App Check token: $e");
      // Optionally throw an exception if token is required
      // throw AppException("Failed to retrieve Firebase App Check token");
    }

    log("Request Headers: $headers");
    return headers;
  }
}
