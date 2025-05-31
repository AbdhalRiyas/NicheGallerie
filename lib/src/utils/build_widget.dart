import 'package:flutter/material.dart';
import 'package:shop/src/components/Banner/M/banner_m_style_1.dart';
import 'package:shop/src/components/Banner/M/banner_m_with_counter.dart';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/config/global_key_constants.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/accord.dart';
import 'package:shop/src/models/brand.dart';
import 'package:shop/src/models/note.dart';
import 'package:shop/src/screens/home/views/components/explore_by_section.dart';
import 'package:shop/src/screens/home/views/components/featured_category_card.dart';
import 'package:shop/src/screens/home/views/components/offers_carousel.dart';
import 'package:shop/src/screens/home/views/components/products_section.dart';
import 'package:shop/src/screens/product/views/products_list_screen.dart';

Widget buildWidget(Map<dynamic, dynamic> json) {
  if (json['widget_name'] == 'carousel') {
    List<Widget> children = [];

    for (var element in json['children']) {
      if (element['type'] == 'normal') {
        children.add(BannerMStyle1(
          image: element['image'],
          ctaText: element['cta_text'] == '' ? null : element['cta_text'],
          press: element['cta_url'] == '' ? () {} : () {},
        ));
      } else if (element['type'] == 'with_counter') {
        children.add(BannerMWithCounter(
          duration: Duration(seconds: element['duration_in_seconds']),
          title: element['title'],
          subtitle: element['subtitle'],
          ctaText: element['cta_text'],
          press: () {},
        ));
      }
    }

    return SliverToBoxAdapter(
      child: OffersCarousel(
        key: Key('carousel'),
        offers: children,
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
              builder: (context) => ProductsListScreen(
                title: json['children'][i]['title'],
                categoryId: json['children'][i]['category_id'].toString(),
                apiEndPoint: ApiContants().products,
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
    // Convert tabs to Map<String, String>
    final Map<String, String> tabs = Map<String, String>.from(
      json['children']['tabs']
          .map((key, value) => MapEntry(key, value.toString())),
    );

    // Parse items into appropriate model lists
    final List<Brand> brands =
        (json['children']['brands'][0]['items'] as List<dynamic>)
            .map((item) => Brand.fromJson(item))
            .toList();
    final List<Accord> accords =
        (json['children']['accords'][0]['items'] as List<dynamic>)
            .map((item) => Accord.fromJson(item))
            .toList();
    final List<Note> notes =
        (json['children']['notes'][0]['items'] as List<dynamic>)
            .map((item) => Note.fromJson(item))
            .toList();

    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: defaultPadding),
      sliver: SliverToBoxAdapter(
        child: ExploreBySection(
          tabs: tabs,
          brands: brands,
          accords: accords,
          notes: notes,
        ),
      ),
    );
  }

  return SliverToBoxAdapter(child: SizedBox());
}
