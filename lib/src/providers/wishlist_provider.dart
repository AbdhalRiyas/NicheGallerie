import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class WishlistProvider extends ChangeNotifier {
  late Box<int> wishlistBox;
  bool _isBoxInitialized = false;

  bool get isBoxInitialized => _isBoxInitialized;

  WishlistProvider() {
    _initBox();
  }

  Future<void> _initBox() async {
    wishlistBox = await Hive.openBox<int>('wishlistBox');
    _isBoxInitialized = true;
    notifyListeners();
  }

  List<int> get wishlistItems {
    if (!_isBoxInitialized) return [];
    return wishlistBox.values.toList();
  }

  void addItem(int productId) {
    if (!_isBoxInitialized) return;

    if (!wishlistItems.contains(productId)) {
      wishlistBox.add(productId);
    }

    notifyListeners();
  }

  void removeItem(int productId) {
    if (!_isBoxInitialized) return;

    int index = wishlistItems.indexOf(productId);

    if (index != -1) {
      wishlistBox.deleteAt(index);
    }

    notifyListeners();
  }
}
