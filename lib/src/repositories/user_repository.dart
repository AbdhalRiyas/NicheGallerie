import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/error/app_exception.dart';
import 'package:shop/src/services/api_service.dart';
import 'package:shop/src/utils/result.dart';

class UserRepository {
  Future<Result> getBillingAddress() async {
    try {
      final res = await ApiService().get(ApiContants().billingAddress);
      return Result(data: res, message: 'Address fetched successfully');
    } on AppException catch (e) {
      return Result(message: e.message.toString());
    } catch (e) {
      return Result(message: 'Unexpected error occured');
    }
  }

  Future<Result> updateBillingAddress(Map<String, dynamic> data) async {
    try {
      final res =
          await ApiService().post(ApiContants().billingAddress, payload: data);
      return Result(data: res['data'], message: res['message']);
    } on AppException catch (e) {
      return Result(message: e.message.toString());
    } catch (e) {
      return Result(message: 'Unexpected error occured');
    }
  }

  Future<Result> storeFcmToken(String token) async {
    try {
      final res = await ApiService()
          .put(ApiContants().storeFcmToken, payload: {'fcm_token': token});
      return Result(data: res['data'], message: res['message']);
    } on AppException catch (e) {
      return Result(message: e.message.toString());
    } catch (e) {
      return Result(message: 'Unexpected error occured');
    }
  }
}
