import 'package:flutter/widgets.dart';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/error/app_exception.dart';
import 'package:shop/src/models/order.dart';
import 'package:shop/src/services/api_service.dart';
import 'package:shop/src/utils/result.dart';

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

  Future<Result> fetchOrders({int page = 1}) async {
    try {
      final res = await ApiService().get(ApiContants().orders);
      List<Order> orders = [];

      for (var order in res) {
        try {
          orders.add(Order.fromJson(order));
        } catch (e, stacktrace) {
          debugPrint(stacktrace.toString());
        }
      }

      return Result(data: orders);
    } on AppException catch (e) {
      return Result(error: e.message);
    } catch (e) {
      return Result(error: 'Unexpected error occured');
    }
  }

  int totalItemsInOrder(List<OrderItem> orderItems) {
    return orderItems.fold(
        0, (previousValue, element) => previousValue + element.quantity);
  }
}
