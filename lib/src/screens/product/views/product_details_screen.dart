import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop/src/components/cart_button.dart';
import 'package:shop/src/components/custom_modal_bottom_sheet.dart';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/product/product.dart';
import 'package:shop/src/screens/product/views/components/accords_bottom_sheet.dart';
import 'package:shop/src/screens/product/views/components/notes_bottom_sheet.dart';
import 'package:shop/src/screens/product/views/product_returns_screen.dart';
import 'package:shop/src/services/api_service.dart';

import 'components/notify_me_card.dart';
import 'components/product_images.dart';
import 'components/product_info.dart';
import 'components/product_list_tile.dart';
import 'product_buy_now_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({
    super.key,
    required this.product,
    required this.images,
  });

  final Product product;
  final List<String> images;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  void getProduct() async {
    final product = await ApiService()
        .get('${ApiContants().products}/${widget.product.id}');
    log(product.toString());
  }

  @override
  void initState() {
    super.initState();
    getProduct();
  }

  @override
  Widget build(BuildContext context) {
    // final List<dynamic> accordsList = widget.product.metadata?['accords_lists'];

    // final List<dynamic> topNotes = widget.product.metadata?['top_notes'];

    // final List<dynamic> middleNotes = widget.product.metadata?['middle_notes'];

    // final List<dynamic> baseNotes = widget.product.metadata?['base_notes'];

    return Scaffold(
      // bottomNavigationBar: product.stockStatus == 'instock'
      //     ? CartButton(
      //         price: product.price,
      //         press: () {
      //           customModalBottomSheet(
      //             context,
      //             height: MediaQuery.of(context).size.height * 0.92,
      //             child: ProductBuyNowScreen(
      //               product: product,
      //             ),
      //           );
      //         },
      //       )
      //     :

      //     /// If profuct is not available then show [NotifyMeCard]
      //     NotifyMeCard(
      //         isNotify: false,
      //         onChanged: (value) {},
      //       ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              floating: true,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    "assets/icons/Bookmark.svg",
                    colorFilter: ColorFilter.mode(
                        Theme.of(context).textTheme.bodyLarge!.color!,
                        BlendMode.srcIn),
                  ),
                ),
              ],
            ),
            ProductImages(
              images: widget.images,
            ),
            // ProductInfo(
            //   brand: "Armani",
            //   title: product.name,
            //   isAvailable: product.stockStatus == 'instock',
            //   description: product.shortDescription,
            //   rating: 4.4,
            //   numOfReviews: 126,
            // ),
            // ProductListTile(
            //   svgSrc: "assets/icons/Layers.svg",
            //   title: "Main Accords",
            //   press: () {
            //     customModalBottomSheet(
            //       context,
            //       child: AccordsBottomSheet(accordsList: accordsList),
            //     );
            //   },
            // ),
            // ProductListTile(
            //   svgSrc: "assets/icons/Drop.svg",
            //   title: "Notes",
            //   press: () {
            //     customModalBottomSheet(
            //       context,
            //       child: NotesBottomSheet(
            //         topNotes: topNotes,
            //         middleNotes: middleNotes,
            //         baseNotes: baseNotes,
            //       ),
            //       // child: const BuyFullKit(
            //       //     images: ["assets/screens/Product detail.png"]),
            //     );
            //   },
            // ),
            // ProductListTile(
            //   svgSrc: "assets/icons/Delivery.svg",
            //   title: "Shipping Information",
            //   press: () {
            //     customModalBottomSheet(
            //       context,
            //       height: MediaQuery.of(context).size.height * 0.92,
            //       child: Placeholder(),
            //       // child: const BuyFullKit(
            //       //   images: ["assets/screens/Shipping information.png"],
            //       // ),
            //     );
            //   },
            // ),
            // ProductListTile(
            //   svgSrc: "assets/icons/Return.svg",
            //   title: "Returns",
            //   isShowBottomBorder: true,
            //   press: () {
            //     customModalBottomSheet(
            //       context,
            //       height: MediaQuery.of(context).size.height * 0.92,
            //       child: const ProductReturnsScreen(),
            //     );
            //   },
            // ),
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
            // SliverPadding(
            //   padding: const EdgeInsets.all(defaultPadding),
            //   sliver: SliverToBoxAdapter(
            //     child: Text(
            //       "You may also like",
            //       style: Theme.of(context).textTheme.titleSmall!,
            //     ),
            //   ),
            // ),
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
            const SliverToBoxAdapter(
              child: SizedBox(height: defaultPadding),
            )
          ],
        ),
      ),
    );
  }
}
