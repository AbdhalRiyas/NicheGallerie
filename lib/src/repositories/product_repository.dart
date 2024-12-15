import 'dart:developer';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/models/product/product.dart';
import 'package:shop/src/services/api_service.dart';
import 'package:shop/src/utils/result.dart';

class ProductRepository {
  Future<Result> fetchProductById(List<dynamic> productIds) async {
    try {
      log(productIds.toString());
      final res = await ApiService()
          .get("${ApiContants().products}?include=${productIds.join(',')}");

      List<Product> products = [];

      for (var prod in res['data']) {
        products.add(Product.fromJson(prod));
      }

      return Result(data: products);
    } catch (e) {
      return Result(error: e.toString());
    }
  }
}
