import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/components/product/product_card.dart';
import 'package:shop/src//route/screen_export.dart';
import 'package:shop/src/components/skeleton/product/products_skelton.dart';
import 'package:shop/src/config/app_config.dart';
import 'package:shop/src/models/product.dart';
import 'package:shop/src/screens/product/views/products_list_screen.dart';
import 'package:shop/src/services/api_service.dart';

import '../../../../constants.dart';

class ProductsSection extends StatefulWidget {
  const ProductsSection({
    super.key,
    required this.title,
    required this.subtitle,
    this.dataApiEndPoint = '',
    this.viewAllVisibility = true,
  });

  final String title, dataApiEndPoint, subtitle;
  final bool viewAllVisibility;

  @override
  State<ProductsSection> createState() => _ProductsSectionState();
}

class _ProductsSectionState extends State<ProductsSection> {
  Future<List<Product?>> _getProducts() async {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                    ),
                    const SizedBox(height: defaultPadding),
                    Text(
                      widget.subtitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.grey[850],
                          ),
                    ),
                    const SizedBox(height: defaultPadding / 2),
                  ],
                ),
              ),
              // if (widget.viewAllVisibility)
              //   GestureDetector(
              //     onTap: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => ProductsListScreen(
              //             title: widget.title,
              //             apiEndPoint: widget.dataApiEndPoint,
              //           ),
              //         ),
              //       );
              //     },
              //     child: Row(
              //       children: [
              //         const Text("View all"),
              //         const SizedBox(width: 8),
              //         SvgPicture.asset(
              //           "assets/icons/Arrow - Right.svg",
              //           colorFilter: const ColorFilter.mode(
              //               Colors.grey, BlendMode.srcIn),
              //         )
              //       ],
              //     ),
              //   ),
            ],
          ),
        ),
        // While loading use 👇
        // const ProductsSkelton(),
        SizedBox(
          height: 220,
          child: FutureBuilder(
              future: _getProducts(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    // Find demoProductsSection on models/ProductModel.dart
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(
                        left: defaultPadding,
                        right: index == snapshot.data!.length - 1
                            ? defaultPadding
                            : 0,
                      ),
                      child: ProductCard(
                        product: snapshot.data![index]!,
                        press: () {
                          context.go(
                              '/$productScreenRoute/${snapshot.data![index]!.slug}');
                        },
                      ),
                    ),
                  );
                }
                return const ProductsSkelton();
              }),
        )
      ],
    );
  }
}
