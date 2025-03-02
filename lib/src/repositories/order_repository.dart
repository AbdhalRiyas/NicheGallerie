import 'package:flutter/widgets.dart';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/error/app_exception.dart';
import 'package:shop/src/models/address_model.dart';
import 'package:shop/src/models/currency.dart';
import 'package:shop/src/models/order.dart';
import 'package:shop/src/models/shipping_model.dart';
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

      return Result(data: orders, message: 'Orders fetched successfully');
    } on AppException catch (e) {
      return Result(message: e.message.toString());
    } catch (e) {
      return Result(message: 'Unexpected error occured');
    }
  }

  int totalItemsInOrder(List<OrderItem> orderItems) {
    return orderItems.fold(
        0, (previousValue, element) => previousValue + element.quantity);
  }

  Future<Result> fetchOrderById(String orderId) async {
    try {
      final res = await ApiService().get("${ApiContants().orders}/$orderId");

      return Result(data: Order.fromJson(res), message: 'Order fetched');
    } on AppException catch (e) {
      return Result(message: e.message.toString());
    } catch (e) {
      return Result(message: 'Unexpected error occured');
    }
  }

  Future<Result> createOrder({
    required Currency currency,
    required Map<String, dynamic> selectedPaymentMethod,
    required AddressModel selectedAddress,
    required List<dynamic> cartItems,
    required double shippingFee,
    required List<Map<dynamic, dynamic>> productMap,
    required ShippingModel selectedShippingMethod,
  }) async {
    try {
      final res = await ApiService()
          .post("${ApiContants().orders}?currency=${currency.code}", payload: {
        'payment_method': selectedPaymentMethod['gateway_id'],
        'payment_method_title': selectedPaymentMethod['title'],
        'billing': {
          'first_name': selectedAddress.firstName,
          'last_name': selectedAddress.lastName,
          'address_1': selectedAddress.address1,
          'address_2': selectedAddress.address2,
          'city': selectedAddress.city,
          'state': selectedAddress.state,
          'postcode': selectedAddress.postcode,
          'country': selectedAddress.country,
          'email': selectedAddress.email,
          'phone': selectedAddress.phone,
        },
        'shipping': {
          'first_name': selectedAddress.firstName,
          'last_name': selectedAddress.lastName,
          'address_1': selectedAddress.address1,
          'address_2': selectedAddress.address2,
          'city': selectedAddress.city,
          'state': selectedAddress.state,
          'postcode': selectedAddress.postcode,
          'country': selectedAddress.country,
        },
        'line_items': cartItems
            .map((e) => {
                  'product_id': e.id,
                  'quantity': productMap.firstWhere(
                      (element) => element['product_id'] == e.id)['qty'],
                })
            .toList(),
        'shipping_lines': [
          {
            'method_id': selectedShippingMethod.methodId,
            'method_title': selectedShippingMethod.title,
            'total': shippingFee.toString(),
          }
        ],
        'fee_lines': [
          {
            'name': 'VAT 5%',
            'total': 23.toString(), // Pass VAT as a string
          }
        ],
      });

      if (res.containsKey('payment_url')) {
        return Result(data: res, message: 'Order created successfully');
      } else {
        return Result(message: 'Error creating order');
      }
    } on AppException catch (e) {
      return Result(message: e.message.toString());
    } catch (e) {
      return Result(message: 'Unexpected error occured');
    }
  }
}
