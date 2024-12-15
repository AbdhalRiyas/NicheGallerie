import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:shop/src/models/product/product.dart';
import 'package:shop/src/repositories/product_repository.dart';
import 'package:shop/src/utils/result.dart';

class CartProvider extends ChangeNotifier {
  final ProductRepository _productRepository = ProductRepository();
  late Box<Map<dynamic, dynamic>> cartBox;
  bool _isBoxInitialized = false;

  bool get isBoxInitialized => _isBoxInitialized;

  CartProvider() {
    _initBox();
  }

  Future<void> _initBox() async {
    cartBox = await Hive.openBox<Map<dynamic, dynamic>>('cartBox');
    _isBoxInitialized = true;

    notifyListeners();
  }

  Future<List<Product>?> fetchProducts() async {
    if (cartItems.isNotEmpty) {
      final Result res = await _productRepository.fetchProductById(
          cartItems.map((item) => item['product_id']).toList());
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

  // double calculateSubTotal() {
  //   if (!_isBoxInitialized) return 0;

  //   double total = 0;
  //   for (var item in cartItems) {
  //     total += item['product_id'].price * item['qty'];
  //   }
  //   return total;
  // }
}
