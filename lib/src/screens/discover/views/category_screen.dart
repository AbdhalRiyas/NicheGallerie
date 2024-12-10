import 'package:flutter/material.dart';
import 'package:shop/src/components/product/product_card.dart';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/category.dart';
import 'package:shop/src/models/product/product.dart';
import 'package:shop/src/route/route_constants.dart';
import 'package:shop/src/services/api_service.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key, required this.category});

  final Category category;

  Future<List<Product?>> _getProducts() async {
    List<Product> products = [];

    final res = await ApiService().get(ApiContants().products);
    for (var element in res) {
      try {
        products.add(Product.fromJson(element));
      } catch (e) {
        print(e);
      }
    }

    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _getProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.hasError) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            return CustomScrollView(
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
                          product: snapshot.data![index]!,
                          press: () {
                            Navigator.pushNamed(
                              context,
                              productDetailsScreenRoute,
                              arguments: [snapshot.data![index]!],
                            );
                          },
                        );
                      },
                      childCount: snapshot.data!.length,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
