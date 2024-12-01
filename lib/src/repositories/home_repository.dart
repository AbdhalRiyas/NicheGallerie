import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/services/api_service.dart';
import 'package:shop/src/utils/result.dart';

class HomeRepository {
  Future<Result> getWidgets() async {
    final res = await ApiService().get(ApiContants().home);
    return Result(data: res);
  }
}
