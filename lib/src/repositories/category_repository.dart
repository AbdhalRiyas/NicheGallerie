import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/models/category.dart';
import 'package:shop/src/services/api_service.dart';
import 'package:shop/src/utils/result.dart';

class CategoryRepository {
  Future<Result> getCategories() async {
    final res = await ApiService().get(ApiContants().categories);

    List<Category> categories = [];

    for (var cat in res) {
      categories.add(Category.fromJson(cat));
    }

    return Result(data: categories);
  }
}
