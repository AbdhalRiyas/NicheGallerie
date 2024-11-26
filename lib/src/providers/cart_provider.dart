import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:shop/src/models/product/product.dart';

class CartProvider extends ChangeNotifier {
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

  List<Map<dynamic, dynamic>> get cartItems {
    if (!_isBoxInitialized) return [];
    return cartBox.values.toList();
  }

  void addItem(Product product) {
    if (!_isBoxInitialized) return;

    int index =
        cartItems.indexWhere((item) => item['product'].id == product.id);

    if (index != -1) {
      cartBox.putAt(
        index,
        {
          "product": product,
          "qty": cartItems[index]['qty'] + 1,
        },
      );
    } else {
      cartBox.add({
        "product": product,
        "qty": 1,
      });
    }

    notifyListeners();
  }

  void decrementQty(Product product) {
    if (!_isBoxInitialized) return;

    int index =
        cartItems.indexWhere((item) => item['product'].id == product.id);

    if (index != -1) {
      final qty = cartItems[index]['qty'];
      if (qty > 1) {
        cartBox.putAt(
          index,
          {
            "product": product,
            "qty": qty - 1,
          },
        );
      } else {
        cartBox.deleteAt(index);
      }

      notifyListeners();
    }
  }

  void incrementQty(Product product) {
    if (!_isBoxInitialized) return;

    int index =
        cartItems.indexWhere((item) => item['product'].id == product.id);

    if (index != -1) {
      cartBox.putAt(
        index,
        {
          "product": product,
          "qty": cartItems[index]['qty'] + 1,
        },
      );
      notifyListeners();
    }
  }

  void removeItem(Product product) {
    if (!_isBoxInitialized) return;

    int index =
        cartItems.indexWhere((item) => item['product'].id == product.id);

    if (index != -1) {
      cartBox.deleteAt(index);
      notifyListeners();
    }
  }

  double calculateSubTotal() {
    if (!_isBoxInitialized) return 0;

    double total = 0;
    for (var item in cartItems) {
      total += item['product'].price * item['qty'];
    }
    return total;
  }
}
