import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/components/cart_button.dart';
import 'package:shop/src/components/custom_modal_bottom_sheet.dart';
import 'package:shop/src/components/custom_snackbar.dart';
import 'package:shop/src/components/product/product_card.dart';
import 'package:shop/src/components/skeleton/product/products_skelton.dart';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/config/app_config.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/product.dart';
import 'package:shop/src/providers/wishlist_provider.dart';
import 'package:shop/src/repositories/product_repository.dart';
import 'package:shop/src/route/route_constants.dart';
import 'package:shop/src/screens/product/views/components/accords_bottom_sheet.dart';
import 'package:shop/src/screens/product/views/components/notes_bottom_sheet.dart';
import 'package:shop/src/screens/product/views/components/product_detail_skeleton.dart';
import 'package:shop/src/services/api_service.dart';

import 'components/request_stock_dialog.dart';
import 'components/product_images.dart';
import 'components/product_info.dart';
import 'components/product_list_tile.dart';
import 'product_buy_now_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({
    super.key,
    required this.slug,
  });

  final String slug;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ValueNotifier<Product?> _product = ValueNotifier(null);

  void getProduct() async {
    final res = await ApiService().get(
        '${ApiContants().products}/${widget.slug}?currency=${context.read<AppConfig>().preferredCurrency['code']}');
    log('Product Details Response: $res');
    _product.value = Product.fromJson(res);
  }

  Future<List<Product>> getRelatedProducts() async {
    final res = await ProductRepository().fetchProductById(
      _product.value!.relatedIds,
      context.read<AppConfig>().preferredCurrency['code']!,
    );
    log('Related Products Request: ${_product.value!.relatedIds}');
    log('Related Products Response: ${res.data.toString()}');
    return res.data as List<Product>;
  }

  @override
  void initState() {
    super.initState();
    getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ValueListenableBuilder(
        builder: (context, Product? product, ch) {
          return product == null
              ? SizedBox()
              : product.stockStatus == 'instock'
                  ? CartButton(
                      price: product.price,
                      press: () {
                        customModalBottomSheet(
                          context,
                          height: MediaQuery.sizeOf(context).height * 0.92,
                          child: ProductBuyNowScreen(
                            product: product,
                          ),
                        );
                      },
                    )
                  : RequestStockDialog(
                      productId: product.id,
                    );
        },
        valueListenable: _product,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              floating: true,
              actions: [
                ValueListenableBuilder(
                  valueListenable: _product,
                  builder: (BuildContext context, value, Widget? child) =>
                      Consumer<WishlistProvider>(
                    builder: (context, wishlistProvider, child) {
                      bool isInWishlist =
                          wishlistProvider.wishlistItems.contains(value?.id);
                      return _product.value == null
                          ? const SizedBox.shrink()
                          : IconButton(
                              onPressed: () {
                                if (isInWishlist) {
                                  wishlistProvider
                                      .removeItem(_product.value!.id);
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    customSnackBar('Removed from wishlist'),
                                  );
                                } else {
                                  wishlistProvider.addItem(_product.value!.id);
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    customSnackBar('Added to wishlist'),
                                  );
                                }
                              },
                              icon: SvgPicture.asset(
                                isInWishlist
                                    ? "assets/icons/Heart-Filled.svg"
                                    : "assets/icons/Heart.svg",
                                colorFilter: isInWishlist
                                    ? const ColorFilter.mode(
                                        Colors.red, BlendMode.srcIn)
                                    : null,
                              ),
                            );
                    },
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: ValueListenableBuilder(
                valueListenable: _product,
                builder: (BuildContext context, Product? product,
                        Widget? child) =>
                    product == null
                        ? ProductDetailsSkeleton()
                        : Column(
                            children: [
                              ProductImages(
                                images: product.images,
                              ),
                              ProductInfo(
                                title: product.name,
                                isAvailable: product.stockStatus == 'instock',
                                description: product.shortDescription,
                                rating: 4.4,
                                numOfReviews: 126,
                              ),
                              ProductListTile(
                                svgSrc: "assets/icons/Layers.svg",
                                title: "Main Accords",
                                press: () {
                                  customModalBottomSheet(
                                    context,
                                    child: AccordsBottomSheet(
                                        accordsList:
                                            product.metadata?['accords_lists']),
                                  );
                                },
                              ),
                              ProductListTile(
                                svgSrc: "assets/icons/Drop.svg",
                                title: "Notes",
                                press: () {
                                  customModalBottomSheet(
                                    context,
                                    child: NotesBottomSheet(
                                      topNotes: product.metadata?['top_notes'],
                                      middleNotes:
                                          product.metadata?['middle_notes'],
                                      baseNotes:
                                          product.metadata?['base_notes'],
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(defaultPadding),
                                child: Text(
                                  "You may also like",
                                  style:
                                      Theme.of(context).textTheme.titleSmall!,
                                ),
                              ),
                              if (product.relatedIds.isNotEmpty)
                                FutureBuilder<List<Product>>(
                                  future: getRelatedProducts(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return ProductsSkelton();
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: Text(
                                          'Error fetching related products',
                                          style: const TextStyle(
                                              color: Colors.red),
                                        ),
                                      );
                                    } else if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return const Center(
                                        child:
                                            Text('No related products found'),
                                      );
                                    } else {
                                      return SizedBox(
                                        height: 250,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (context, index) {
                                            final relatedProduct =
                                                snapshot.data![index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ProductCard(
                                                press: () {
                                                  log(
                                                    'Navigating to product:/$productScreenRoute/${relatedProduct.slug}',
                                                  );
                                                  context.push(
                                                    '/$productScreenRoute/${relatedProduct.slug}',
                                                  );
                                                },
                                                product: relatedProduct,
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  },
                                )
                              else
                                const SizedBox.shrink(),
                            ],
                          ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: defaultPadding),
            )
          ],
        ),
      ),
    );
  }
}
