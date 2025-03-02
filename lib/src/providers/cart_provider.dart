import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shop/src/models/product.dart';
import 'package:shop/src/providers/auth_provider.dart';
import 'package:shop/src/repositories/product_repository.dart';
import 'package:shop/src/utils/result.dart';

class CartProvider extends ChangeNotifier {
  final ProductRepository _productRepository = ProductRepository();
  final AuthProvider authProvider;
  late Box<Map<dynamic, dynamic>> cartBox;
  bool _isBoxInitialized = false;

  bool get isBoxInitialized => _isBoxInitialized;

  CartProvider(this.authProvider) {
    _initBox();
  }

  Future<void> _initBox() async {
    cartBox = await Hive.openBox<Map<dynamic, dynamic>>('cartBox');
    _isBoxInitialized = true;

    notifyListeners();
  }

  Future<List<Product>?> fetchProducts(String currencyCode) async {
    if (cartItems.isNotEmpty) {
      final Result res = await _productRepository.fetchProductById(
          cartItems.map((item) => item['product_id']).toList(), currencyCode);
      return res.data;
    }
    return null;
  }

  List<Map<dynamic, dynamic>> get cartItems {
    if (!_isBoxInitialized) return [];
    return cartBox.values.toList();
  }

  void addItem(int productId, int qty) {
    if (!_isBoxInitialized) return;

    if (!authProvider.isLoggedIn) {
      throw Exception('User not logged in');
    }

    int index = cartItems.indexWhere((item) => item['product_id'] == productId);

    if (index != -1) {
      cartBox.putAt(
        index,
        {
          "product_id": productId,
          "qty": cartItems[index]['qty'] + qty,
        },
      );
    } else {
      cartBox.add({
        "product_id": productId,
        "qty": qty,
      });
    }

    notifyListeners();
  }

  // void updateQty(int productId, int qty) {
  //   if (!_isBoxInitialized) return;

  //   int index = cartItems.indexWhere((item) => item['product_id'] == productId);

  //   if (index != -1) {
  //     if (qty > 0) {
  //       cartBox.putAt(
  //         index,
  //         {
  //           "product_id": productId,
  //           "qty": qty,
  //         },
  //       );
  //     } else {
  //       cartBox.deleteAt(index);
  //     }

  //     notifyListeners();
  //   }
  // }

  void decrementQty(int productId) {
    if (!_isBoxInitialized) return;

    int index = cartItems.indexWhere((item) => item['product_id'] == productId);

    if (index != -1) {
      final qty = cartItems[index]['qty'];
      if (qty > 1) {
        cartBox.putAt(
          index,
          {
            "product_id": productId,
            "qty": qty - 1,
          },
        );
      } else {
        cartBox.deleteAt(index);
      }

      notifyListeners();
    }
  }

  void incrementQty(int productId) {
    if (!_isBoxInitialized) return;

    int index = cartItems.indexWhere((item) => item['product_id'] == productId);

    if (index != -1) {
      cartBox.putAt(
        index,
        {
          "product_id": productId,
          "qty": cartItems[index]['qty'] + 1,
        },
      );
      notifyListeners();
    }
  }

  void removeItem(int productId) {
    if (!_isBoxInitialized) return;

    int index = cartItems.indexWhere((item) => item['product_id'] == productId);

    if (index != -1) {
      cartBox.deleteAt(index);
      notifyListeners();
    }
  }

  // clear cart
  void clearCart() {
    if (!_isBoxInitialized) return;

    cartBox.clear();
    notifyListeners();
  }
}
