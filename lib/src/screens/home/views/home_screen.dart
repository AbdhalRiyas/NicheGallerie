import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/screens/home/views/components/products_section.dart';

import 'components/explore_by_section.dart';
import 'components/featured_category_card.dart';
import 'components/offers_carousel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: OffersCarousel()),
            SliverToBoxAdapter(
                child: ProductsSection(
              title: "Featured",
              viewAllVisibility: false,
              dataApiEndPoint: "${ApiContants().products}?category=791",
            )),

            SliverPadding(
              padding: EdgeInsets.symmetric(
                vertical: defaultPadding * 1.5,
                horizontal: defaultPadding,
              ),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    FeaturedCategoryCard(
                      title: "Men",
                      imageUrl:
                          "https://nichegallerie.com/wp-content/uploads/2023/02/men-perfume-buy-male-fragrance-nichegallerie.com-niche-gallerie-niche-gallery-uae-best-online-fragrance-perfume-buy-store.jpg.jpg",
                      press: () {},
                    ),
                    SizedBox(width: 5),
                    FeaturedCategoryCard(
                      title: "Women",
                      imageUrl:
                          "https://nichegallerie.com/wp-content/uploads/2023/03/women-perfume-buy-female-fragrance-nichegallerie.com-niche-gallerie-niche-gallery-uae-best-online-fragrance-perfume-online-store-1.jpg",
                      press: () {},
                    ),
                    SizedBox(width: 5),
                    FeaturedCategoryCard(
                      title: "Unisex",
                      imageUrl:
                          "https://nichegallerie.com/wp-content/uploads/2023/02/nichegallerie.com-niche-gallerie-niche-gallery-uae-best-online-fragrance-perfume-buy-store.jpg",
                      press: () {},
                    ),
                  ],
                ),
              ),
            ),
            // SliverPadding(
            //   padding: EdgeInsets.symmetric(vertical: defaultPadding * 1.5),
            //   sliver: SliverToBoxAdapter(
            //     child: Column(
            //       children: [
            //         // While loading use 👇
            //         // const BannerMSkelton(),‚
            //         BannerSStyle1(
            //           title: "Men",
            //           subtitle: "Men's Perfume For Your Masculine Spirit",
            //           image:
            //               "https://nichegallerie.com/wp-content/uploads/2023/02/men-perfume-buy-male-fragrance-nichegallerie.com-niche-gallerie-niche-gallery-uae-best-online-fragrance-perfume-buy-store.jpg.jpg",
            //           press: () {
            //             Navigator.pushNamed(context, onSaleScreenRoute);
            //           },
            //         ),
            //         const SizedBox(height: defaultPadding / 4),
            //         // We have 4 banner styles, all in the pro version
            //       ],
            //     ),
            //   ),
            // ),
            SliverPadding(
              padding: EdgeInsets.only(bottom: defaultPadding * 1.5),
              sliver: SliverToBoxAdapter(
                child: ProductsSection(
                  title: "New Arrivals",
                  dataApiEndPoint: "${ApiContants().products}?category=791",
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: defaultPadding),
              sliver: SliverToBoxAdapter(
                child: ExploreBySection(),
              ),
            ),
            // SliverToBoxAdapter(
            //   child: Column(
            //     children: [
            //       // While loading use 👇
            //       // const BannerMSkelton(),‚
            //       BannerSStyle1(
            //         title: "Women",
            //         subtitle: "Fragrances to Empower Your Feminine Side",
            //         image:
            //             "https://nichegallerie.com/wp-content/uploads/2023/03/women-perfume-buy-female-fragrance-nichegallerie.com-niche-gallerie-niche-gallery-uae-best-online-fragrance-perfume-online-store-1.jpg",
            //         press: () {
            //           Navigator.pushNamed(context, onSaleScreenRoute);
            //         },
            //       ),
            //       const SizedBox(height: defaultPadding / 4),
            //     ],
            //   ),
            // ),
            SliverToBoxAdapter(
              child: ProductsSection(
                title: "Best Sellers",
                dataApiEndPoint: "${ApiContants().products}?category=791",
              ),
            ),
            // SliverPadding(
            //   sliver: SliverToBoxAdapter(
            //     child: Column(
            //       children: [
            //         const SizedBox(height: defaultPadding * 1.5),

            //         const SizedBox(height: defaultPadding / 4),
            //         // While loading use 👇
            //         // const BannerSSkelton(),
            //         BannerSStyle1(
            //           title: "Unisex",
            //           subtitle: "Limitless Scents Beyond Genders",
            //           image:
            //               "https://nichegallerie.com/wp-content/uploads/2023/02/nichegallerie.com-niche-gallerie-niche-gallery-uae-best-online-fragrance-perfume-buy-store.jpg",
            //           press: () {
            //             Navigator.pushNamed(context, onSaleScreenRoute);
            //           },
            //         ),
            //         const SizedBox(height: defaultPadding / 4),
            //       ],
            //     ),
            //   ),
            //   padding: EdgeInsets.only(bottom: defaultPadding * 1.5),
            // ),
          ],
        ),
      ),
    );
  }
}
