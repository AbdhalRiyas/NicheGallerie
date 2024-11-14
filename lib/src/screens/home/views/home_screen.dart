import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/screens/home/views/components/products_section.dart';

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

class ExploreBySection extends StatefulWidget {
  const ExploreBySection({
    super.key,
  });

  @override
  State<ExploreBySection> createState() => _ExploreBySectionState();
}

class _ExploreBySectionState extends State<ExploreBySection> {
  int _activeTab = 0;
  final ScrollController _scrollController = ScrollController();
  Timer? _autoScrollTimer;

  final List _tabs = [
    {
      "id": 0,
      "name": "Brands",
      "items": [
        "https://nichegallerie.com/wp-content/uploads/2023/04/buy-tom-ford-perfume-fragrance-for-women-men-niche-gallery-nichegallerie.com_.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/buy-tom-ford-perfume-fragrance-for-women-men-niche-gallery-nichegallerie.com_.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/buy-tom-ford-perfume-fragrance-for-women-men-niche-gallery-nichegallerie.com_.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/buy-tom-ford-perfume-fragrance-for-women-men-niche-gallery-nichegallerie.com_.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/buy-tom-ford-perfume-fragrance-for-women-men-niche-gallery-nichegallerie.com_.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/buy-tom-ford-perfume-fragrance-for-women-men-niche-gallery-nichegallerie.com_.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/buy-tom-ford-perfume-fragrance-for-women-men-niche-gallery-nichegallerie.com_.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/buy-tom-ford-perfume-fragrance-for-women-men-niche-gallery-nichegallerie.com_.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/buy-tom-ford-perfume-fragrance-for-women-men-niche-gallery-nichegallerie.com_.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/buy-tom-ford-perfume-fragrance-for-women-men-niche-gallery-nichegallerie.com_.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/buy-tom-ford-perfume-fragrance-for-women-men-niche-gallery-nichegallerie.com_.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/buy-tom-ford-perfume-fragrance-for-women-men-niche-gallery-nichegallerie.com_.jpg",
      ]
    },
    {
      "id": 1,
      "name": "Accords",
      "items": [
        "https://nichegallerie.com/wp-content/uploads/2023/04/powdery-perfume-accord-buy-nichegallerie.com-perfume-niche-gallery.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/powdery-perfume-accord-buy-nichegallerie.com-perfume-niche-gallery.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/powdery-perfume-accord-buy-nichegallerie.com-perfume-niche-gallery.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/powdery-perfume-accord-buy-nichegallerie.com-perfume-niche-gallery.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/powdery-perfume-accord-buy-nichegallerie.com-perfume-niche-gallery.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/powdery-perfume-accord-buy-nichegallerie.com-perfume-niche-gallery.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/powdery-perfume-accord-buy-nichegallerie.com-perfume-niche-gallery.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/powdery-perfume-accord-buy-nichegallerie.com-perfume-niche-gallery.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/powdery-perfume-accord-buy-nichegallerie.com-perfume-niche-gallery.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/powdery-perfume-accord-buy-nichegallerie.com-perfume-niche-gallery.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/powdery-perfume-accord-buy-nichegallerie.com-perfume-niche-gallery.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/powdery-perfume-accord-buy-nichegallerie.com-perfume-niche-gallery.jpg",
      ]
    },
    {
      "id": 2,
      "name": "Notes",
      "items": [
        "https://nichegallerie.com/wp-content/uploads/2023/04/Patchouli-note-perfume-nichegallerie.com-niche-gallery-buy-perfume.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/Patchouli-note-perfume-nichegallerie.com-niche-gallery-buy-perfume.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/Patchouli-note-perfume-nichegallerie.com-niche-gallery-buy-perfume.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/Patchouli-note-perfume-nichegallerie.com-niche-gallery-buy-perfume.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/Patchouli-note-perfume-nichegallerie.com-niche-gallery-buy-perfume.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/Patchouli-note-perfume-nichegallerie.com-niche-gallery-buy-perfume.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/Patchouli-note-perfume-nichegallerie.com-niche-gallery-buy-perfume.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/Patchouli-note-perfume-nichegallerie.com-niche-gallery-buy-perfume.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/Patchouli-note-perfume-nichegallerie.com-niche-gallery-buy-perfume.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/Patchouli-note-perfume-nichegallerie.com-niche-gallery-buy-perfume.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/Patchouli-note-perfume-nichegallerie.com-niche-gallery-buy-perfume.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/Patchouli-note-perfume-nichegallerie.com-niche-gallery-buy-perfume.jpg",
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (_scrollController.hasClients) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.position.pixels;
        double nextScroll = (currentScroll + 100).clamp(0, maxScroll);
        _scrollController.animateTo(nextScroll,
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Explore By",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Row(
                children: _tabs
                    .map((tab) => TextButton(
                          onPressed: _activeTab == tab['id']
                              ? null
                              : () {
                                  setState(() {
                                    _activeTab = tab['id'];
                                  });
                                },
                          child: Text(tab['name']),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 50,
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [Colors.transparent, Colors.black],
                stops: [0.1, 1.0],
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstIn,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: _tabs[_activeTab]['items'].length,
              itemBuilder: (BuildContext context, int index) => Padding(
                padding: EdgeInsets.only(
                  left: defaultPadding,
                ),
                child: CachedNetworkImage(
                    imageUrl: _tabs[_activeTab]['items'][index]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
