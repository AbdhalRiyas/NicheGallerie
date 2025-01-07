import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shop/src/config/app_contants.dart';
import 'package:shop/src/error/app_exception.dart';

class ApiService {
  ApiService._internal();
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  Future<dynamic> get(String apiEndPoint) async {
    final Uri uri = Uri.parse("${AppContants().apiBaseUrl}$apiEndPoint");

    try {
      final res = await http
          .get(
            uri,
            headers: _buildHeaders(),
          )
          .timeout(
            const Duration(seconds: 10),
          );
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
      final res = await http
          .post(
            uri,
            headers: _buildHeaders(),
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 30));
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

    // final userToken = Hive.box("app").get("user");

    try {
      final res = await http
          .put(
            uri,
            // headers: _buildHeaders(userToken),
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
      final res = await http
          .delete(
            uri,
            // headers: _buildHeaders(userToken),
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
          responseJson["message"] ?? "Something went wrong. Please try again.",
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

  Map<String, String> _buildHeaders() {
    final consumerKey = 'ck_73560b846cff25ae31200f6b105007a1e46a1766';
    final consumerSecret = 'cs_413054aed9df66e9b134aeefd591a0c06eb6c15e';
    final authString =
        base64Encode(utf8.encode('$consumerKey:$consumerSecret'));
    return {
      "Authorization": "Basic $authString",
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Connection": "Keep-Alive",
    };
  }
}
