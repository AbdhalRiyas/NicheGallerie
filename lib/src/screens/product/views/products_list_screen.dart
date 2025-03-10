import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop/src/components/product/product_card.dart';
import 'package:shop/src/components/skeleton/product/products_skelton.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/product.dart';
import 'package:shop/src/route/route_constants.dart';
import 'package:shop/src/services/api_service.dart';

class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen(
      {super.key, required this.title, required this.apiEndPoint});

  final String title;
  final String apiEndPoint;

  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<Product> _products = [];
  bool _isLoadingMore = false;
  int _currentPage = 1;
  int _lastPage = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMore);
    _getProducts();
  }

  Future<void> _getProducts({int page = 1}) async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final res = await ApiService().get("${widget.apiEndPoint}&page=$page");

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title.toUpperCase()),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.symmetric(
            //       horizontal: defaultPadding, vertical: defaultPadding / 2),
            //   child: SearchForm(
            //     suffixIcon: "assets/icons/Setting.svg",
            //     onTabFilter: () {
            //       showModalBottomSheet(
            //         context: context,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.vertical(
            //               top: Radius.circular(defaultBorderRadius)),
            //         ),
            //         isScrollControlled: true,
            //         builder: (context) => CustomBottomSheet(),
            //       );
            //     },
            //   ),
            // ),
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
                      child: ProductsSkelton(),
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
