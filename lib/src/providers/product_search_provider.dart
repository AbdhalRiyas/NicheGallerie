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

  void _onSearchChanged(String query) {
    _searchQuery = query;
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      if (query.length > 3) {
        _currentPage = 1;
        _products.clear();
        _fetchResults(query: query);
      }
    });
  }

  Future<void> _fetchResults({String query = '', int page = 1}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await _apiService
          .get('${ApiContants().products}?search=$query&page=$page');

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

  void search(String query) {
    _onSearchChanged(query);
  }

  void loadMore() {
    if (_currentPage < _lastPage) {
      _currentPage++;
      _fetchResults(query: _searchQuery, page: _currentPage);
    }
  }
}
