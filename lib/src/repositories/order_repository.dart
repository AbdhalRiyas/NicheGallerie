import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/models/order.dart';
import 'package:shop/src/services/api_service.dart';

class OrderRepository {
  // Private constructor
  OrderRepository._privateConstructor();

  // Singleton instance
  static final OrderRepository _instance =
      OrderRepository._privateConstructor();

  // Factory constructor to return the same instance
  factory OrderRepository() {
    return _instance;
  }

  Future<List<Order>> fetchOrders({int page = 1}) async {
    try {
      final res = await ApiService().get(ApiContants().orders);
      print(res);
      return [];
    } catch (e) {
      return [];
    }
  }
}
