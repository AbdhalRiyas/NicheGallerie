import 'package:flutter/material.dart';
import 'package:shop/src/config/global_key_constants.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/category.dart';
import 'package:shop/src/screens/discover/views/category_screen.dart';
import 'package:shop/src/screens/home/views/components/explore_by_section.dart';
import 'package:shop/src/screens/home/views/components/featured_category_card.dart';
import 'package:shop/src/screens/home/views/components/offers_carousel.dart';
import 'package:shop/src/screens/home/views/components/products_section.dart';

Widget buildWidget(Map<dynamic, dynamic> json) {
  if (json['widget_name'] == 'carousel') {
    return const SliverToBoxAdapter(
      child: OffersCarousel(
        key: Key('carousel'),
      ),
    );
  }

  if (json['widget_name'] == 'product_section') {
    return SliverToBoxAdapter(
        child: ProductsSection(
      title: json['child']['title'],
      viewAllVisibility: json['child']['view_all_visibility'],
      dataApiEndPoint: json['child']['data_api_end_point'],
    ));
  }

  if (json['widget_name'] == 'featured_category_section') {
    final List<Widget> children = [];

    for (int i = 0; i < json['children'].length; i++) {
      children.add(FeaturedCategoryCard(
        title: json['children'][i]['title'],
        imageUrl: json['children'][i]['image_url'],
        press: () {
          Navigator.push(
            GlobalKeyContants().navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => CategoryScreen(
                category: Category(
                  id: json['children'][i]['catagory_id'],
                  parent: 0,
                  name: json['children'][i]['title'],
                  slug: json['children'][i]['category_slug'],
                  image: json['children'][i]['image_url'],
                ),
              ),
            ),
          );
        },
      ));

      if (i < json['children'].length - 1) {
        children.add(SizedBox(width: 5));
      }
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(
        vertical: defaultPadding * 1.5,
        horizontal: defaultPadding,
      ),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: children,
        ),
      ),
    );
  }

  if (json['widget_name'] == 'explore_by_section') {
    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: defaultPadding),
      sliver: SliverToBoxAdapter(
        child: ExploreBySection(),
      ),
    );
  }

  return SliverToBoxAdapter(child: SizedBox());
}
