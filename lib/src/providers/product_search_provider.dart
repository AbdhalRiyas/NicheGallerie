import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/error/app_exception.dart';
import 'package:shop/src/models/product.dart';
import 'package:shop/src/services/api_service.dart';

class ProductSearchProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final List<Product> _products = [];
  int _currentPage = 1;
  int _lastPage = 1;
  bool _isLoading = false;
  String _productSearchMsg =
      'Start typing to search for the products you need.';
  Timer? _debounce;

  String _searchQuery = '';

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String get productSearchMsg => _productSearchMsg;

  void reset() {
    _products.clear();
    _currentPage = 1;
    _lastPage = 1;
    _isLoading = false;
    _productSearchMsg = 'Start typing to search for the products you need.';
    _searchQuery = '';
    _debounce?.cancel();
    notifyListeners();
  }

  void _onSearchChanged(String query,
      {String category = '', Map<String, String>? taxanomy}) {
    _searchQuery = query;
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      if (query.length > 3) {
        _currentPage = 1;
        _products.clear();
        _fetchResults(
          query: query,
          category: category,
          taxanomy: taxanomy,
        );
      }
    });
  }

  Future<void> _fetchResults(
      {String query = '',
      int page = 1,
      String category = '',
      Map<String, String>? taxanomy}) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Build the base URL with query and page
      String url = '${ApiContants().products}?search=$query&page=$page';

      // Only append category if it's not empty
      if (category.isNotEmpty) {
        url += '&category=$category';
      }

      // Append taxanomy if provided
      if (taxanomy != null && taxanomy.isNotEmpty) {
        taxanomy.forEach((key, value) {
          url += '&$key=$value';
        });
      }

      log('Fetching products from: $url');

      final res = await _apiService.get(url);

      for (var element in res['data']) {
        try {
          _products.add(Product.fromJson(element));
        } catch (e) {
          log(e.toString());
        }
      }

      _currentPage = res['pagination']['current_page'];
      _lastPage = res['pagination']['last_page'];
    } on AppException catch (e) {
      _productSearchMsg = e.message.toString();
    } catch (e) {
      _productSearchMsg = 'An unexpected error occurred';
    }

    if (_products.isEmpty) {
      _productSearchMsg = 'No products found for your search.';
    }

    _isLoading = false;
    notifyListeners();
  }

  void search(String query,
      {String? category = '', Map<String, String>? taxanomy}) {
    _onSearchChanged(
      query,
      category: category!,
      taxanomy: taxanomy,
    );
  }

  void loadMore({String? category = '', Map<String, String>? taxanomy}) {
    if (_currentPage < _lastPage) {
      _currentPage++;
      _fetchResults(
        query: _searchQuery,
        page: _currentPage,
        category: category!,
        taxanomy: taxanomy,
      );
    }
  }
}
