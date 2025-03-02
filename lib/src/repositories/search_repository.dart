import 'package:fpdart/fpdart.dart';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/error/app_exception.dart';
import 'package:shop/src/models/product.dart';
import 'package:shop/src/services/api_service.dart';

class SearchRepository {
  Future<Either<String, List<Product>>> searchProducts(String query) async {
    try {
      // Call the API service
      final res =
          await ApiService().get('${ApiContants().products}?search=$query');

      // Map the response to a list of Product objects
      final products =
          (res as List).map((json) => Product.fromJson(json)).toList();

      // Return the list of products wrapped in a Right
      return Right(products);
    } on AppException catch (e) {
      // Handle specific AppException and return it wrapped in a Left
      return Left(e.message ?? 'An unexpected error occurred');
    } catch (e) {
      // Handle generic exceptions
      return Left('An unexpected error occurred');
    }
  }
}
