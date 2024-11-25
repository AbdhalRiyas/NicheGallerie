import 'package:flutter/foundation.dart';
import 'package:shop/src/models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> cartItems = [];

  void addItem(Product product) {
    int index =
        cartItems.indexWhere((item) => item['product'].id == product.id);

    if (index != -1) {
      cartItems[index]['qty']++;
    } else {
      cartItems.add({
        "product": product,
        "qty": 1,
      });
    }

    notifyListeners();
  }

  void decrementQty(Product product) {
    int index =
        cartItems.indexWhere((item) => item['product'].id == product.id);

    if (index != -1) {
      if (cartItems[index]['qty'] > 1) {
        cartItems[index]['qty']--;
      } else {
        cartItems.removeAt(index);
      }

      notifyListeners();
    }
  }
}
