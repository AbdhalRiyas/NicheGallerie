import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/components/product/product_card.dart';
import 'package:shop/src/route/screen_export.dart';
import 'package:shop/src/components/skeleton/product/products_skelton.dart';
import 'package:shop/src/config/app_config.dart';
import 'package:shop/src/models/product.dart';
import 'package:shop/src/screens/product/views/products_list_screen.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/services/api_service.dart';

class ProductsSection extends StatefulWidget {
  const ProductsSection({
    super.key,
    required this.title,
    required this.subtitle,
    this.dataApiEndPoint = '',
    this.viewAllVisibility = true,
    this.isListView = false,
  });

  final String title, dataApiEndPoint, subtitle;
  final bool viewAllVisibility;
  final bool isListView;

  @override
  State<ProductsSection> createState() => _ProductsSectionState();
}

class _ProductsSectionState extends State<ProductsSection> {
  Future<List<Product>> _getProducts() async {
    List<Product> products = [];

    if (widget.dataApiEndPoint.isNotEmpty) {
      final res = await ApiService().get(
          '${widget.dataApiEndPoint}&currency=${context.read<AppConfig>().preferredCurrency['code']}');
      for (var element in res['data']) {
        try {
          products.add(Product.fromJson(element));
        } catch (e) {
          log(e.toString());
        }
      }
    }

    return products;
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(defaultPadding),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.title,
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontSize: 24,
                                  ),
                        ),
                        const SizedBox(height: defaultPadding),
                        Text(
                          widget.subtitle,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.grey[850],
                                  ),
                        ),
                        const SizedBox(height: defaultPadding / 2),
                      ],
                    ),
                  ),
                ],
              ),
              FutureBuilder<List<Product>>(
                future: _getProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return widget.isListView
                        ? ProductsSkelton()
                        : ProductsSkelton(
                            gridCount: 4,
                            isGrid: true,
                          );
                  }
                  if (snapshot.hasError) {
                    return const Text('Error loading products');
                  }
                  if (snapshot.hasData &&
                      snapshot.data != null &&
                      snapshot.data!.isNotEmpty) {
                    final products = snapshot.data!;
                    // final crossAxisCount = 2;
                    // final rowCount = (products.length / crossAxisCount).ceil();
                    // final itemHeight = 300.0 * 0.6; // childAspectRatio = 0.6
                    // final gridHeight = rowCount * itemHeight +
                    //     (rowCount - 1) * (defaultPadding / 2);

                    return SizedBox(
                      child: widget.isListView
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: defaultPadding / 2),
                                  child: ProductCard(
                                    product: products[index],
                                    press: () {
                                      context.go(
                                          '/$productScreenRoute/${products[index].slug}');
                                    },
                                    isListview: true, // Pass to ProductCard
                                  ),
                                );
                              },
                            )
                          : GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: defaultPadding,
                                crossAxisSpacing: defaultPadding,
                                childAspectRatio: 0.66,
                              ),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    right:
                                        index % 2 == 0 ? defaultPadding / 2 : 0,
                                  ),
                                  child: ProductCard(
                                    product: products[index],
                                    press: () {
                                      context.go(
                                          '/$productScreenRoute/${products[index].slug}');
                                    },
                                  ),
                                );
                              },
                            ),
                    );
                  }
                  return const Text('No products found');
                },
              ),
              if (widget.viewAllVisibility) ...[
                SizedBox(height: defaultPadding),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120, 40),
                    backgroundColor: const Color.fromARGB(255, 255, 94, 83),
                    foregroundColor: Colors.white,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding / 2),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductsListScreen(
                          title: widget.title,
                          apiEndPoint: widget.dataApiEndPoint,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'View ${widget.title}'.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                    semanticsLabel: 'View all ${widget.title} products',
                  ),
                ),
              ]
            ],
          ),
        ]),
      ),
    );
  }
}
