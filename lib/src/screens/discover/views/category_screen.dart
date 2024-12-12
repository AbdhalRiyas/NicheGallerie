import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop/src/components/custom_modal_bottom_sheet.dart';
import 'package:shop/src/components/product/product_card.dart';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/category.dart';
import 'package:shop/src/models/product/product.dart';
import 'package:shop/src/route/route_constants.dart';
import 'package:shop/src/screens/search/views/components/search_form.dart';
import 'package:shop/src/services/api_service.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key, required this.category});

  final Category category;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
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
      final res =
          await ApiService().get('${ApiContants().products}?page=$page');
      log(res['pagination'].toString());

      final List<Product> newProducts = [];
      for (var element in res['data']) {
        try {
          newProducts.add(Product.fromJson(element));
        } catch (e) {
          print(e);
        }
      }

      setState(() {
        _products.addAll(newProducts);
        _currentPage = res['pagination']['current_page'];
        _lastPage = res['pagination']['last_page'];
      });
    } catch (e) {
      print(e);
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
        title: Text(widget.category.name),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding / 2),
              child: SearchForm(
                suffixIcon: "assets/icons/Setting.svg",
                onTabFilter: () {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(defaultBorderRadius)),
                    ),
                    isScrollControlled: true,
                    builder: (context) => CustomBottomSheet(),
                  );
                },
              ),
            ),
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
                              Navigator.pushNamed(
                                context,
                                productDetailsScreenRoute,
                                arguments: [_products[index]],
                              );
                            },
                          );
                        },
                        childCount: _products.length,
                      ),
                    ),
                  ),
                  if (_isLoadingMore)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(defaultPadding),
                        child: Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
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

class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({super.key});

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

RangeValues _currentRangeValues = const RangeValues(99, 10000);
Set<String> selectedCategories = {};
String selectedSort = '';

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Sort and Filter
      child: SizedBox(
        height:
            MediaQuery.of(context).size.height * 0.7, // Adjust height as needed
        child: Column(
          children: [
            TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: primaryColor,
              tabs: [
                Tab(text: 'Sort'),
                Tab(text: 'Filter'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Tab 1: Sort
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ...[
                          'Newest Arrival',
                          'Most Popular',
                          'Price : High to Low',
                          'Price : Low to High',
                          'Name : A to Z',
                          'Name : Z to A'
                        ].map((option) => RadioListTile(
                              activeColor: primaryColor,
                              title: Text(option),
                              value: option,
                              groupValue: selectedSort,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedSort = value!;
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                            )),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  // Tab 2: Filter
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stock Status
                        const Text(
                          'Stock Status',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CheckboxListTile(
                          title: const Text('In stock Only'),
                          activeColor: primaryColor,
                          value: false,
                          onChanged: (bool? value) {},
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                        ),

                        // Category
                        const Text(
                          'Category',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ...[
                          'Collectible',
                          'Featured',
                          'Men',
                          'Unboxed',
                          'Unisex',
                          'Women'
                        ].map((category) => CheckboxListTile(
                              activeColor: primaryColor,
                              title: Text(
                                category,
                              ),
                              value: selectedCategories.contains(category),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value ?? false) {
                                    selectedCategories.add(category);
                                  } else {
                                    selectedCategories.remove(category);
                                  }
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                            )),

                        // Dropdowns
                        // const SizedBox(height: 16),
                        ExpansionTile(
                          title: const Text('Brands'),
                          children: const [
                            // Add brand options here
                          ],
                        ),
                        ExpansionTile(
                          title: const Text('Notes'),
                          children: const [
                            // Add notes options here
                          ],
                        ),
                        ExpansionTile(
                          title: const Text('Accords'),
                          children: const [
                            // Add accords options here
                          ],
                        ),

                        // Price Range
                        const SizedBox(height: 16),
                        const Text(
                          'Price Range',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        RangeSlider(
                          values: _currentRangeValues,
                          min: 99,
                          max: 10000,
                          activeColor: Colors.brown,
                          inactiveColor: Colors.brown.withOpacity(0.2),
                          onChanged: (RangeValues values) {
                            setState(() {
                              _currentRangeValues = values;
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'MIN ${_currentRangeValues.start.round()}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const Text(' — '),
                            Text(
                              '${_currentRangeValues.end.round()} MAX',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Handle apply filters
                  Navigator.pop(context);
                },
                child: const Text(
                  'APPLY',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
