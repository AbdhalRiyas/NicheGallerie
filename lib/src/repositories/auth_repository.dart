import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/services/api_service.dart';
import 'package:shop/src/utils/result.dart';

class AuthRepository {
  Future<Result?> login(String username, String password) async {
    final res = await ApiService().post(ApiContants().login, payload: {
      'username': username,
      'password': password,
    });

    return Result(data: res);
  }
}
