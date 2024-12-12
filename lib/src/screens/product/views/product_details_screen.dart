import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/components/cart_button.dart';
import 'package:shop/src/components/custom_modal_bottom_sheet.dart';
import 'package:shop/src/components/custom_snackbar.dart';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/product/product.dart';
import 'package:shop/src/providers/wishlist_provider.dart';
import 'package:shop/src/screens/product/views/components/accords_bottom_sheet.dart';
import 'package:shop/src/screens/product/views/components/notes_bottom_sheet.dart';
import 'package:shop/src/screens/product/views/product_returns_screen.dart';
import 'package:shop/src/services/api_service.dart';

import 'components/product_images.dart';
import 'components/product_info.dart';
import 'components/product_list_tile.dart';
import 'product_buy_now_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({
    super.key,
    required this.productImageUrls,
    required this.productId,
  });

  final int productId;
  final List<String> productImageUrls;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ValueNotifier<Product?> _product = ValueNotifier(null);

  void getProduct() async {
    final res =
        await ApiService().get('${ApiContants().products}/${widget.productId}');

    _product.value = Product.fromJson(res);
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
                          height: MediaQuery.of(context).size.height * 0.92,
                          child: ProductBuyNowScreen(
                            product: product,
                          ),
                        );
                      },
                    )
                  : SizedBox();

          /// If profuct is not available then show [NotifyMeCard]
          // NotifyMeCard(
          //     isNotify: false,
          //     onChanged: (value) {},
          //   );
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
                Consumer<WishlistProvider>(
                  builder: (context, wishlistProvider, child) {
                    bool isInWishlist = wishlistProvider.wishlistItems
                        .contains(widget.productId);
                    return IconButton(
                      onPressed: () {
                        if (isInWishlist) {
                          wishlistProvider.removeItem(widget.productId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            customSnackBar('Removed from wishlist'),
                          );
                        } else {
                          wishlistProvider.addItem(widget.productId);
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
              ],
            ),
            ProductImages(
              images: widget.productImageUrls,
            ),
            SliverToBoxAdapter(
              child: ValueListenableBuilder(
                valueListenable: _product,
                builder: (BuildContext context, Product? product,
                        Widget? child) =>
                    product == null
                        ? CircularProgressIndicator.adaptive()
                        : Column(
                            children: [
                              ProductInfo(
                                brand: "Armani",
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
                                    // child: const BuyFullKit(
                                    //     images: ["assets/screens/Product detail.png"]),
                                  );
                                },
                              ),
                              ProductListTile(
                                svgSrc: "assets/icons/Delivery.svg",
                                title: "Shipping Information",
                                press: () {
                                  customModalBottomSheet(
                                    context,
                                    height: MediaQuery.of(context).size.height *
                                        0.92,
                                    child: Placeholder(),
                                    // child: const BuyFullKit(
                                    //   images: ["assets/screens/Shipping information.png"],
                                    // ),
                                  );
                                },
                              ),
                              ProductListTile(
                                svgSrc: "assets/icons/Return.svg",
                                title: "Returns",
                                isShowBottomBorder: true,
                                press: () {
                                  customModalBottomSheet(
                                    context,
                                    height: MediaQuery.of(context).size.height *
                                        0.92,
                                    child: const ProductReturnsScreen(),
                                  );
                                },
                              ),
                              // const SliverToBoxAdapter(
                              //   child: Padding(
                              //     padding: EdgeInsets.all(defaultPadding),
                              //     child: ReviewCard(
                              //       rating: 4.3,
                              //       numOfReviews: 128,
                              //       numOfFiveStar: 80,
                              //       numOfFourStar: 30,
                              //       numOfThreeStar: 5,
                              //       numOfTwoStar: 4,
                              //       numOfOneStar: 1,
                              //     ),
                              //   ),
                              // ),
                              // ProductListTile(
                              //   svgSrc: "assets/icons/Chat.svg",
                              //   title: "Reviews",
                              //   isShowBottomBorder: true,
                              //   press: () {
                              //     Navigator.pushNamed(context, productReviewsScreenRoute);
                              //   },
                              // ),
                              Padding(
                                padding: const EdgeInsets.all(defaultPadding),
                                child: Text(
                                  "You may also like",
                                  style:
                                      Theme.of(context).textTheme.titleSmall!,
                                ),
                              ),
                              // SliverToBoxAdapter(
                              //   child: SizedBox(
                              //     height: 220,
                              //     child: ListView.builder(
                              //       scrollDirection: Axis.horizontal,
                              //       itemCount: 5,
                              //       itemBuilder: (context, index) => Padding(
                              //         padding: EdgeInsets.only(
                              //             left: defaultPadding,
                              //             right: index == 4 ? defaultPadding : 0),
                              //         child: ProductCard(
                              //           image: productDemoImg2,
                              //           title: "Sleeveless Tiered Dobby Swing Dress",
                              //           price: 24.65,
                              //           priceAfterDiscount: index.isEven ? 20.99 : null,
                              //           dicountpercent: index.isEven ? 25 : null,
                              //           press: () {},
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
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
