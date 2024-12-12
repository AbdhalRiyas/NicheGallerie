import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shop/src/models/product/product.dart';
import 'package:shop/src/repositories/product_repository.dart';
import 'package:shop/src/utils/result.dart';

class WishlistProvider extends ChangeNotifier {
  final ProductRepository _productRepository = ProductRepository();
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

  Future<List<Product>?> fetchProducts() async {
    if (wishlistItems.isNotEmpty) {
      final Result res =
          await _productRepository.fetchWishlistProducts(wishlistItems);
      return res.data;
    }
    return null;
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
