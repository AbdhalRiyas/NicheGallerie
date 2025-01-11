import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/error/app_exception.dart';
import 'package:shop/src/services/api_service.dart';
import 'package:shop/src/utils/result.dart';

class HomeRepository {
  Future<Result> getWidgets(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      final res = await ApiService().get(ApiContants().home);
      return Result(data: res);
    } on AppException catch (e) {
      log(e.toString());
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
            e.message.toString(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return Result(error: e.toString());
    }
  }
}
