import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shop/src/components/empty_handle_widget.dart';
import 'package:shop/src/models/product.dart';
import 'package:shop/src/repositories/search_repository.dart';

import 'components/search_form.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchRepository _repository = SearchRepository();
  final ScrollController _scrollController = ScrollController();
  List<Product> _products = [];
  int _page = 1;
  bool _isLoading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      _fetchResults();
    }
  }

  void _onSearchChanged(query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      if (query.length > 3) {
        _page = 1;
        _products.clear();
        _fetchResults(query: query);
      }
    });
  }

  Future<void> _fetchResults({String query = ''}) async {
    setState(() {
      _isLoading = true;
    });

    final response = await _repository.searchProducts(query);

    if (response.isSuccess) {
      setState(() {
        _products = response.data;
      });

      _page++;
    } else {
      // Handle error
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchForm(
          autofocus: true,
          hintText: 'Search for products...',
          onChanged: _onSearchChanged,
        ),
      ),
      body: _products.isEmpty
          ? EmptyHandleWidget(
              iconSrc: "assets/icons/Search.svg",
              title: "Start typing to search for the products you need.",
            )
          : ListView.builder(
              controller: _scrollController,
              itemCount: _products.length + 1,
              itemBuilder: (context, index) {
                if (index == _products.length) {
                  return _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox.shrink();
                }
                return ListTile(
                  title: Text(_products[index].name),
                );
              },
            ),
    );
  }
}
