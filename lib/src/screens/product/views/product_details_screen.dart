import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/components/custom_snackbar.dart';
import 'package:shop/src/components/product/product_card.dart';
import 'package:shop/src/components/skeleton/product/products_skelton.dart';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/config/app_config.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/product.dart';
import 'package:shop/src/providers/cart_provider.dart';
import 'package:shop/src/repositories/product_repository.dart';
import 'package:shop/src/route/route_constants.dart';
import 'package:shop/src/screens/custom_appbar.dart';
import 'package:shop/src/screens/product/views/components/custom_tabs.dart';
import 'package:shop/src/screens/product/views/components/product_detail_skeleton.dart';
import 'package:shop/src/screens/product/views/components/product_quantity.dart';
import 'package:shop/src/screens/product/views/components/unit_price.dart';
import 'package:shop/src/screens/product/views/products_list_screen.dart';
import 'package:shop/src/services/api_service.dart';

import 'components/request_stock_dialog.dart';
import 'components/product_images.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({
    super.key,
    required this.slug,
  });

  final String slug;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<Product?> _product = ValueNotifier(null);
  late TabController _tabController;

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
    return res.data as List<Product>;
  }

  @override
  void initState() {
    super.initState();
    getProduct();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int qty = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: ValueListenableBuilder(
                valueListenable: _product,
                builder: (BuildContext context, Product? product,
                        Widget? child) =>
                    product == null
                        ? ProductDetailsSkeleton()
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(defaultPadding),
                                child: Text(
                                  product.name.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                ),
                              ),
                              ProductImages(
                                images: product.images,
                                productId: product.id,
                              ),
                              Center(
                                child: Column(
                                  children: [
                                    UnitPrice(
                                      price: product.regularPrice,
                                      priceAfterDiscount: product.price,
                                    ),
                                    if (product.regularPrice >
                                        product.price) ...[
                                      const SizedBox(
                                          height: defaultPadding / 2),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Discount: ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                            TextSpan(
                                              text:
                                                  '${((product.regularPrice - product.price) / product.regularPrice * 100).toStringAsFixed(0)}% OFF',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: defaultPadding),
                                    product.stockStatus == 'instock'
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ProductQuantity(
                                                showLabel: false,
                                                numOfItem: qty,
                                                onIncrement: !product
                                                            .manageStock ||
                                                        qty <
                                                            product
                                                                .stockQuantity
                                                    ? () {
                                                        setState(() {
                                                          qty++;
                                                        });
                                                      }
                                                    : null,
                                                onDecrement: qty > 1
                                                    ? () {
                                                        if (qty > 1) {
                                                          setState(() {
                                                            qty--;
                                                          });
                                                        }
                                                      }
                                                    : null,
                                              ),
                                              const SizedBox(
                                                  width: defaultPadding),
                                              Consumer<CartProvider>(
                                                builder: (context, cartProvider,
                                                    child) {
                                                  return ElevatedButton.icon(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      minimumSize:
                                                          const Size(150, 40),
                                                      backgroundColor: cartProvider
                                                              .cartItems
                                                              .any((item) =>
                                                                  item[
                                                                      'product_id'] ==
                                                                  product.id)
                                                          ? sandDuneColor
                                                          : Colors.red,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 6,
                                                        horizontal: 16,
                                                      ),
                                                    ),
                                                    onPressed: !product
                                                                .manageStock ||
                                                            qty <=
                                                                product
                                                                    .stockQuantity
                                                        ? () {
                                                            try {
                                                              cartProvider
                                                                  .addItem(
                                                                product.id,
                                                                qty,
                                                              );
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                customSnackBar(
                                                                  'Added to cart',
                                                                  action:
                                                                      SnackBarAction(
                                                                    label:
                                                                        'View Cart',
                                                                    onPressed:
                                                                        () {
                                                                      context.go(
                                                                          '/$cartScreenRoute');
                                                                    },
                                                                  ),
                                                                ),
                                                              );
                                                            } catch (e) {
                                                              context.go(
                                                                  '/$logInScreenRoute');
                                                            }
                                                          }
                                                        : null,
                                                    label: Text(
                                                      'Add to Cart'
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    icon: SvgPicture.asset(
                                                      "assets/icons/cart.svg",
                                                      colorFilter:
                                                          ColorFilter.mode(
                                                        Colors.white,
                                                        BlendMode.srcIn,
                                                      ),
                                                    ),
                                                    iconAlignment:
                                                        IconAlignment.end,
                                                  );
                                                },
                                              )
                                            ],
                                          )
                                        : RequestStockDialog(
                                            productId: product.id,
                                          ),
                                    const SizedBox(height: defaultPadding / 2),
                                    CachedNetworkImage(
                                      imageUrl:
                                          'https://nichegallerie.com/wp-content/uploads/2023/03/tabby-tammarah-1536x295.webp',
                                      height: 50,
                                      width: 200,
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: defaultPadding,
                                  vertical: defaultPadding,
                                ),
                                child: Divider(
                                  color: Colors.grey.withAlpha(150),
                                  height: defaultPadding,
                                ),
                              ),
                              // Tabs for Accords and Notes
                              Padding(
                                padding: const EdgeInsets.all(defaultPadding),
                                child: CustomTabSwitcher(
                                    metadata: product.metadata),
                              ),
                              // Brand image
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: defaultPadding,
                                  ),
                                  child: product.brand != null
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductsListScreen(
                                                      title:
                                                          product.brand!.name,
                                                      apiEndPoint: ApiContants()
                                                          .products,
                                                      taxanomy: {
                                                        "brands":
                                                            product.brand!.slug,
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    width: 0.5,
                                                  ),
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      product.brand!.imageUrl,
                                                  height: 80,
                                                  width: 80,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              product.shortDescription,
                                              maxLines: 5,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    color: Colors.black54,
                                                  ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(defaultPadding),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Perfumes You May Like",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                  ),
                                ),
                              ),
                              if (product.relatedIds.isNotEmpty)
                                FutureBuilder<List<Product>>(
                                  future: getRelatedProducts(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return ProductsSkelton(
                                        isGrid: true,
                                        gridCount: 2,
                                      );
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
                                        height: 280,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (context, index) {
                                            final relatedProduct =
                                                snapshot.data![index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                width: 160,
                                                child: ProductCard(
                                                  press: () {
                                                    log('Navigating to product:/$productScreenRoute/${relatedProduct.slug}');
                                                    context.push(
                                                        '/$productScreenRoute/${relatedProduct.slug}');
                                                  },
                                                  product: relatedProduct,
                                                ),
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
