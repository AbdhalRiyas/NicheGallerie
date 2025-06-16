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

    for (var element in json['children'] ?? []) {
      if (element['type'] == 'normal') {
        children.add(BannerMStyle1(
          image: element['image'] ?? '',
          ctaText: element['cta_text']?.isNotEmpty ?? false
              ? element['cta_text']
              : null,
          press: element['cta_url']?.isNotEmpty ?? false ? () {} : () {},
        ));
      } else if (element['type'] == 'with_counter') {
        children.add(BannerMWithCounter(
          duration: Duration(seconds: element['duration_in_seconds'] ?? 0),
          title: element['title'] ?? '',
          subtitle: element['subtitle'] ?? '',
          ctaText: element['cta_text'] ?? '',
          press: () {},
        ));
      }
    }

    return SliverToBoxAdapter(
      child: OffersCarousel(
        key: const Key('carousel'),
        offers: children,
      ),
    );
  }

  if (json['widget_name'] == 'product_section') {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding),
      sliver: ProductsSection(
        title: json['child']?['title']?.toString() ?? '',
        subtitle: json['child']?['subtitle']?.toString() ?? '',
        viewAllVisibility: json['child']?['view_all_visibility'] ?? true,
        dataApiEndPoint: json['child']?['data_api_end_point']?.toString() ?? '',
        isListView: json['child']?['is_list_view'] ?? true,
      ),
    );
  }

  if (json['widget_name'] == 'featured_category_section') {
    final List<Widget> children = [];

    for (int i = 0; i < (json['children']?.length ?? 0); i++) {
      children.add(FeaturedCategoryCard(
        title: json['children'][i]['title'] ?? '',
        subtitle: json['children'][i]['subtitle'] ?? '',
        imageUrl: json['children'][i]['image_url'] ?? '',
        press: () {
          Navigator.push(
            GlobalKeyContants().navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => ProductsListScreen(
                title: json['children'][i]['title'] ?? '',
                categoryId:
                    json['children'][i]['category_id']?.toString() ?? '',
                apiEndPoint: ApiContants().products,
              ),
            ),
          );
        },
      ));

      if (i < (json['children']?.length ?? 0) - 1) {
        children.add(const SizedBox(height: defaultPadding));
      }
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(
        vertical: defaultPadding * 1.5,
        // horizontal: defaultPadding,
      ),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }

  if (json['widget_name'] == 'explore_by_section') {
    final Map<String, Map<String, String>> tabs =
        Map<String, Map<String, String>>.from(
      (json['children']?['tabs'] ?? {}).map((key, value) => MapEntry(
            key,
            {
              'key': value['key']?.toString() ?? '',
              'description': value['description']?.toString() ?? '',
            },
          )),
    );

    final List<Brand> brands =
        (json['children']?['brands']?[0]['items'] as List<dynamic>? ?? [])
            .map((item) => Brand.fromJson(item))
            .toList();
    final List<Accord> accords =
        (json['children']?['accords']?[0]['items'] as List<dynamic>? ?? [])
            .map((item) => Accord.fromJson(item))
            .toList();
    final List<Note> notes =
        (json['children']?['notes']?[0]['items'] as List<dynamic>? ?? [])
            .map((item) => Note.fromJson(item))
            .toList();

    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding),
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

  return const SliverToBoxAdapter(child: SizedBox.shrink());
}
