import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/components/cart_button.dart';
import 'package:shop/src/components/custom_modal_bottom_sheet.dart';
import 'package:shop/src/components/network_image_with_loader.dart';
import 'package:shop/src/models/product.dart';
import 'package:shop/src/providers/cart_provider.dart';
import 'package:shop/src/screens/product/views/added_to_cart_message_screen.dart';
import 'package:shop/src/screens/product/views/components/selected_colors.dart';
import 'package:shop/src/screens/product/views/components/selected_size.dart';

import '../../../constants.dart';
import 'components/product_quantity.dart';
import 'components/unit_price.dart';

class ProductBuyNowScreen extends StatefulWidget {
  const ProductBuyNowScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductBuyNowScreen> createState() => _ProductBuyNowScreenState();
}

class _ProductBuyNowScreenState extends State<ProductBuyNowScreen> {
  int qty = 1;
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder:
          (BuildContext context, CartProvider cartProvider, Widget? child) {
        return Scaffold(
          bottomNavigationBar: CartButton(
            price: widget.product.price * qty,
            title: "Add to cart",
            subTitle: "Total price",
            press: () {
              cartProvider.addItem(
                widget.product.id,
                qty,
              );
              customModalBottomSheet(
                context,
                isDismissible: false,
                child: const AddedToCartMessageScreen(),
              );
            },
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding / 2, vertical: defaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BackButton(),
                    Expanded(
                      child: Text(
                        widget.product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        "assets/icons/Bookmark.svg",
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).textTheme.bodyLarge!.color!,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: defaultPadding),
                        child: AspectRatio(
                          aspectRatio: 1.05,
                          child: NetworkImageWithLoader(
                              widget.product.images.first),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(defaultPadding),
                      sliver: SliverToBoxAdapter(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: UnitPrice(
                                price: widget.product.regularPrice,
                                priceAfterDiscount: widget.product.price,
                              ),
                            ),
                            ProductQuantity(
                              numOfItem: qty,
                              onIncrement: () {
                                setState(() {
                                  qty++;
                                });
                              },
                              onDecrement: () {
                                if (qty > 1) {
                                  setState(() {
                                    qty--;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: Divider()),
                    SliverToBoxAdapter(
                      child: SelectedColors(
                        colors: const [
                          Color(0xFFEA6262),
                          Color(0xFFB1CC63),
                          Color(0xFFFFBF5F),
                          Color(0xFF9FE1DD),
                          Color(0xFFC482DB),
                        ],
                        selectedColorIndex: 2,
                        press: (value) {},
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SelectedSize(
                        sizes: const ["S", "M", "L", "XL", "XXL"],
                        selectedIndex: 1,
                        press: (value) {},
                      ),
                    ),
                    // SliverPadding(
                    //   padding:
                    //       const EdgeInsets.symmetric(vertical: defaultPadding),
                    //   sliver: ProductListTile(
                    //     title: "Size guide",
                    //     svgSrc: "assets/icons/Sizeguid.svg",
                    //     isShowBottomBorder: true,
                    //     press: () {
                    //       customModalBottomSheet(
                    //         context,
                    //         height: MediaQuery.of(context).size.height * 0.9,
                    //         child: const SizeGuideScreen(),
                    //       );
                    //     },
                    //   ),
                    // ),
                    // SliverPadding(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: defaultPadding),
                    //   sliver: SliverToBoxAdapter(
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         const SizedBox(height: defaultPadding / 2),
                    //         Text(
                    //           "Store pickup availability",
                    //           style: Theme.of(context).textTheme.titleSmall,
                    //         ),
                    //         const SizedBox(height: defaultPadding / 2),
                    //         const Text(
                    //             "Select a size to check store availability and In-Store pickup options.")
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // SliverPadding(
                    //   padding:
                    //       const EdgeInsets.symmetric(vertical: defaultPadding),
                    //   sliver: ProductListTile(
                    //     title: "Check stores",
                    //     svgSrc: "assets/icons/Stores.svg",
                    //     isShowBottomBorder: true,
                    //     press: () {
                    //       customModalBottomSheet(
                    //         context,
                    //         height: MediaQuery.of(context).size.height * 0.92,
                    //         child:
                    //             const LocationPermissonStoreAvailabilityScreen(),
                    //       );
                    //     },
                    //   ),
                    // ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: defaultPadding,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
