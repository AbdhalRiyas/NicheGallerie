import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/components/product/product_card.dart';
import 'package:shop/src/config/app_config.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/product.dart';
import 'package:shop/src/providers/wishlist_provider.dart';
import 'package:shop/src/route/screen_export.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WishlistProvider>(
      builder: (BuildContext context, WishlistProvider wishlistProvider,
              Widget? child) =>
          wishlistProvider.wishlistItems.isEmpty
              ? const Center(
                  child: Text("No Bookmarks"),
                )
              : FutureBuilder(
                  future: wishlistProvider.fetchProducts(
                      context.read<AppConfig>().preferredCurrency['code']),
                  builder: (BuildContext context,
                          AsyncSnapshot<List<Product>?> snapshot) =>
                      !snapshot.hasData
                          ? const Center(
                              child: Text("No Bookmarks"),
                            )
                          : CustomScrollView(
                              slivers: [
                                SliverPadding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: defaultPadding,
                                      vertical: defaultPadding),
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
                                          product: snapshot.data![index],
                                          press: () {
                                            Navigator.pushNamed(context,
                                                productDetailsScreenRoute,
                                                arguments: [
                                                  snapshot.data![index]
                                                ]);
                                          },
                                        );
                                      },
                                      childCount: snapshot.data?.length,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                ),

      // CustomScrollView(
      //   slivers: [
      // While loading use 👇
      //  BookMarksSlelton(),

      //   ],
      // ),
    );
  }
}
