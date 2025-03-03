import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/error/app_exception.dart';
import 'package:shop/src/models/product.dart';
import 'package:shop/src/services/api_service.dart';
import 'package:shop/src/utils/result.dart';

class SearchRepository {
  Future<Result> searchProducts(String query) async {
    try {
      // Call the API service
      final res =
          await ApiService().get('${ApiContants().products}?search=$query');

      print(res);

      // Map the response to a list of Product objects
      final products =
          (res['data'] as List).map((json) => Product.fromJson(json)).toList();

      print(products);

      // Return the list of products wrapped in a Right
      return Result(message: "Products fetched", data: products);
    } on AppException catch (e) {
      // Handle specific AppException and return it wrapped in a Left
      return Result(message: e.message.toString());
    } catch (e) {
      // Handle generic exceptions
      return Result(message: 'An unexpected error occurred');
    }
  }
}
