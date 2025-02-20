import 'package:flutter/material.dart';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/error/app_exception.dart';
import 'package:shop/src/services/api_service.dart';
import 'package:shop/src/utils/result.dart';

class HomeRepository {
  Future<Result> getWidgets(BuildContext context) async {
    try {
      final res = await ApiService().get(ApiContants().home);
      return Result(data: res, message: 'Widgets fetched successfully');
    } on AppException catch (e) {
      return Result(message: e.message.toString());
    } catch (e) {
      return Result(message: 'Unexpected error occured');
    }
  }
}
