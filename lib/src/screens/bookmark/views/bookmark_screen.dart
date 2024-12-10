import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/providers/wishlist_provider.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<WishlistProvider>(
        builder: (BuildContext context, WishlistProvider wishlistProvider,
                Widget? child) =>
            wishlistProvider.wishlistItems.isEmpty
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
                              return Text(
                                wishlistProvider.wishlistItems[index]
                                    .toString(),
                              );
                            },
                            childCount: wishlistProvider.wishlistItems.length,
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
      // SliverPadding(
      //   padding: const EdgeInsets.symmetric(
      //       horizontal: defaultPadding, vertical: defaultPadding),
      //   sliver: SliverGrid(
      //     gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
      //       maxCrossAxisExtent: 200.0,
      //       mainAxisSpacing: defaultPadding,
      //       crossAxisSpacing: defaultPadding,
      //       childAspectRatio: 0.66,
      //     ),
      //     delegate: SliverChildBuilderDelegate(
      //       (BuildContext context, int index) {
      //         return ProductCard(
      //           image: demoPopularProducts[index].image,
      //           title: demoPopularProducts[index].title,
      //           price: demoPopularProducts[index].price,
      //           priceAfterDiscount:
      //               demoPopularProducts[index].priceAfterDiscount,
      //           dicountpercent: demoPopularProducts[index].dicountpercent,
      //           press: () {
      //             Navigator.pushNamed(context, productDetailsScreenRoute);
      //           },
      //         );
      //       },
      //       childCount: demoPopularProducts.length,
      //     ),
      //   ),
      // ),
      //   ],
      // ),
    );
  }
}
