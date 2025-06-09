import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/models/accord.dart';
import 'package:shop/src/models/brand.dart';
import 'package:shop/src/models/note.dart';
import 'package:shop/src/models/product.dart';
import 'package:shop/src/services/api_service.dart';
import 'package:shop/src/utils/result.dart';

class ProductRepository {
  Future<Result> fetchProductById(
      List<dynamic> productIds, String currencyCode) async {
    try {
      final res = await ApiService().get(
          "${ApiContants().products}?include=${productIds.join(',')}&currency=$currencyCode");

      List<Product> products = [];

      for (var prod in res['data']) {
        products.add(Product.fromJson(prod));
      }

      return Result(data: products, message: 'Products fetched successfully');
    } catch (e) {
      return Result(message: e.toString());
    }
  }

  Future<Result> requestStock(int productId, String whatsappNumber) async {
    try {
      final res = await ApiService().post(
        ApiContants().requestStock,
        payload: {
          'product_id': productId.toString(),
          'whatsapp_number': whatsappNumber,
        },
      );
      return Result(data: res['data'], message: res['message']);
    } catch (e) {
      return Result(message: e.toString());
    }
  }

  Future<Map<String, dynamic>> fetchBrands() async {
    try {
      final res = await ApiService().get(ApiContants().brands);
      List<Brand> brands =
          (res as List).map((brand) => Brand.fromJson(brand)).toList();
      return {
        'items': brands,
      };
    } catch (e) {
      throw Exception('Failed to fetch brands: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> fetchAccords({int page = 1}) async {
    try {
      final res = await ApiService().get('${ApiContants().accords}?page=$page');
      List<Accord> accords = (res['data'] as List)
          .map((accord) => Accord.fromJson(accord))
          .toList();
      return {
        'items': accords,
        'next_page_url': res['next_page_url'],
      };
    } catch (e) {
      throw Exception('Failed to fetch accords: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> fetchNotes({int page = 1}) async {
    try {
      final res = await ApiService().get('${ApiContants().notes}?page=$page');
      List<Note> notes =
          (res['data'] as List).map((note) => Note.fromJson(note)).toList();
      return {
        'items': notes,
        'next_page_url': res['next_page_url'],
      };
    } catch (e) {
      throw Exception('Failed to fetch notes: ${e.toString()}');
    }
  }
}
