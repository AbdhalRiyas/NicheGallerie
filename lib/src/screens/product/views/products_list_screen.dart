import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shop/src/components/product/product_card.dart';
import 'package:shop/src/components/skeleton/product/products_skelton.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/product.dart';
import 'package:shop/src/route/route_constants.dart';
import 'package:shop/src/screens/product/views/components/custom_bottom_sheet.dart';
import 'package:shop/src/services/api_service.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text('Search results for "$query"'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? []
        : ['Product 1', 'Product 2', 'Product 3']
            .where((product) =>
                product.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            query = suggestions[index];
            showResults(context);
          },
        );
      },
    );
  }
}

class ProductsListScreen extends StatefulWidget {
  ProductsListScreen(
      {super.key,
      required this.title,
      required this.apiEndPoint,
      String? categoryId})
      : categoryId =
            Uri.parse(apiEndPoint).queryParameters['category'] ?? categoryId;

  final String title;
  final String apiEndPoint;
  final String? categoryId;

  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<Product> _products = [];
  bool _isLoadingMore = false;
  int _currentPage = 1;
  int _lastPage = 1;
  Map<String, dynamic> _filters = {
    'selectedSort': 'popularity',
    'inStockOnly': false,
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMore);
    _getProducts();
  }

  Future<void> _getProducts({int page = 1, bool reset = false}) async {
    if (_isLoadingMore) return;

    setState(() {
      if (reset) {
        _currentPage = 1;
        _lastPage = 1;
        _products.clear();
      }
      _isLoadingMore = true;
    });

    try {
      final queryParameters = {
        'category': widget.categoryId,
        'orderby': (_filters['selectedSort']
                ?.replaceAll(RegExp(r'(_asc|_desc)$'), '') ??
            'popularity'),
        'order':
            _filters['selectedSort']?.endsWith('_asc') == true ? 'asc' : 'desc',
        'page': page.toString(),
      };

      if (_filters['inStockOnly'] == true) {
        queryParameters['stock_status'] = 'instock';
      }

      final Uri uri = Uri.parse(widget.apiEndPoint)
          .replace(queryParameters: queryParameters);

      final res = await ApiService().get(uri.toString());

      log(res['pagination'].toString());

      final List<Product> newProducts = [];
      for (var element in res['data']) {
        try {
          newProducts.add(Product.fromJson(element));
        } catch (e) {
          log(e.toString());
        }
      }

      setState(() {
        if (page == 1) {
          _products.clear();
        }
        _products.addAll(newProducts);
        _currentPage = res['pagination']['current_page'];
        _lastPage = res['pagination']['last_page'];
      });
    } catch (e) {
      log(e.toString());
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  void _loadMore() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _currentPage < _lastPage) {
      _getProducts(page: _currentPage + 1);
    }
  }

  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      _filters = filters;
    });
    _getProducts(page: 1, reset: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title.toUpperCase()),
        actions: [
          IconButton(
            onPressed: () {
              // create search
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
            icon: SvgPicture.asset(
              "assets/icons/Search.svg",
              height: 24,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).textTheme.bodyLarge!.color!,
                  BlendMode.srcIn),
            ),
          ),
          IconButton(
            onPressed: () {
              // create filter
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(defaultBorderRadius)),
                ),
                isScrollControlled: true,
                builder: (context) => CustomBottomSheet(
                  inStockOnly: _filters['inStockOnly'],
                  initialRangeValues: _filters['rangeValues'],
                  initialSelectedCategories: _filters['selectedCategories'],
                  initialSelectedSort: _filters['selectedSort'],
                  onChanged: (filters) {
                    _applyFilters(filters);
                  },
                ),
              );
            },
            icon: SvgPicture.asset(
              "assets/icons/Sort.svg",
              height: 24,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).textTheme.bodyLarge!.color!,
                  BlendMode.srcIn),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding, vertical: defaultPadding),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200.0,
                        mainAxisSpacing: defaultPadding,
                        crossAxisSpacing: defaultPadding,
                        childAspectRatio: 0.66,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return ProductCard(
                            product: _products[index],
                            press: () {
                              context.go(
                                  '/$productScreenRoute/${_products[index].slug}');
                            },
                          );
                        },
                        childCount: _products.length,
                      ),
                    ),
                  ),
                  if (_isLoadingMore)
                    const SliverToBoxAdapter(
                      child: ProductsSkelton(
                        isGrid: true,
                        gridCount: 6, // Adjust as needed
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
