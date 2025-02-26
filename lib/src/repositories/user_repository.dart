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
}
