import 'package:flutter/material.dart';
import 'package:shop/src/components/product/product_card.dart';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/category.dart';
import 'package:shop/src/models/product/product.dart';
import 'package:shop/src/route/route_constants.dart';
import 'package:shop/src/services/api_service.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key, required this.category});

  final Category category;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ScrollController _scrollController = ScrollController();

  Future<List<Product?>> _getProducts() async {
    List<Product> products = [];

    final res = await ApiService().get(ApiContants().products);
    for (var element in res['data']) {
      try {
        products.add(Product.fromJson(element));
      } catch (e) {
        print(e);
      }
    }

    return products;
  }

  @override
  void initState() {
    _scrollController.addListener(_loadMore);
    super.initState();
  }

  void _loadMore() {
    print(_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
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
