import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/components/product/product_card.dart';
import 'package:shop/src/components/skeleton/product/products_skelton.dart';
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
          Widget? child) {
        return wishlistProvider.wishlistItems.isEmpty
            ? const Center(
                child: Text("No products in your wishlist"),
              )
            : FutureBuilder(
                future: wishlistProvider.fetchProducts(
                    context.read<AppConfig>().preferredCurrency['code']),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Product>?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ProductsSkelton(),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("No products in your wishlist"),
                    );
                  }
                  final products = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(bottom: defaultPadding / 2),
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
                  );
                },
              );
      },

      // CustomScrollView(
      //   slivers: [
      // While loading use 👇
      //  BookMarksSlelton(),

      //   ],
      // ),
    );
  }
}
