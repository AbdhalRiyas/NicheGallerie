import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/components/empty_handle_widget.dart';
import 'package:shop/src/components/product/product_card.dart';
import 'package:shop/src/components/skeleton/product/products_skelton.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/providers/product_search_provider.dart';
import 'package:shop/src/route/route_constants.dart';

import 'components/search_form.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final provider =
          Provider.of<ProductSearchProvider>(context, listen: false);
      if (!provider.isLoading) {
        provider.loadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchForm(
          autofocus: true,
          hintText: 'Search for products...',
          onChanged: (query) {
            Provider.of<ProductSearchProvider>(context, listen: false)
                .search(query!);
          },
        ),
      ),
      body: Consumer<ProductSearchProvider>(
        builder: (context, provider, child) {
          if (provider.products.isEmpty) {
            return EmptyHandleWidget(
              iconSrc: "assets/icons/Search.svg",
              title: provider.productSearchMsg,
            );
          } else {
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
                          product: provider.products[index],
                          press: () {
                            context.go(
                                '/$productScreenRoute/${provider.products[index].slug}');
                          },
                        );
                      },
                      childCount: provider.products.length,
                    ),
                  ),
                ),
                if (provider.isLoading)
                  SliverToBoxAdapter(child: ProductsSkelton())
              ],
            );
          }
        },
      ),
    );
  }
}
