import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop/src/components/cart_button.dart';
import 'package:shop/src/components/custom_modal_bottom_sheet.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/product/product.dart';
import 'package:shop/src/screens/product/views/components/accords_bottom_sheet.dart';
import 'package:shop/src/screens/product/views/components/notes_bottom_sheet.dart';
import 'package:shop/src/screens/product/views/product_returns_screen.dart';

import 'components/notify_me_card.dart';
import 'components/product_images.dart';
import 'components/product_info.dart';
import 'components/product_list_tile.dart';
import 'product_buy_now_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final accordsList = [
      {
        "accord-name": "WOODY",
        "accord-link": "https://staging19.nichegallerie.com/accords/woody/",
        "accord-percentage": "100",
        "accord-image": "6706"
      },
      {
        "accord-name": "AMBER",
        "accord-link": "https://staging19.nichegallerie.com/accords/amber/",
        "accord-percentage": "70",
        "accord-image": "6707"
      },
      {
        "accord-name": "ANIMALIC",
        "accord-link": "https://staging19.nichegallerie.com/accords/animalic/",
        "accord-percentage": "50",
        "accord-image": "6708"
      },
    ];

    final List<Map<String, String>> topNotes = [
      {
        "top-note-name": "Pear",
        "top-note-link": "https://staging19.nichegallerie.com/notes/pear/",
        "top-note-image": "7414"
      },
      {
        "top-note-name": "Pomelo",
        "top-note-link": "https://staging19.nichegallerie.com/notes/pomelo/",
        "top-note-image": "14627"
      }
    ];

    final List<Map<String, String>> middleNotes = [
      {
        "middle-note-name": "Rose",
        "middle-note-link": "https://staging19.nichegallerie.com/notes/rose/",
        "middle-note-image": "6684"
      },
      {
        "middle-note-name": "Olibanum",
        "middle-note-link":
            "https://staging19.nichegallerie.com/notes/olibanum",
        "middle-note-image": "7017"
      },
      {
        "middle-note-name": "Cloves",
        "middle-note-link": "https://staging19.nichegallerie.com/notes/cloves",
        "middle-note-image": "7143"
      },
      {
        "middle-note-name": "Cinnamon",
        "middle-note-link":
            "https://staging19.nichegallerie.com/notes/cinnamon",
        "middle-note-image": "6685"
      },
      {
        "middle-note-name": "Cumin",
        "middle-note-link": "https://staging19.nichegallerie.com/notes/cumin",
        "middle-note-image": "6686"
      }
    ];

    final List<Map<String, String>> baseNotes = [
      {
        "base-note-name": "Cedar",
        "base-note-link": "https://staging19.nichegallerie.com/notes/cedar/",
        "base-note-image": "7102"
      },
      {
        "base-note-name": "Vetiver",
        "base-note-link": "https://staging19.nichegallerie.com/notes/vetiver/",
        "base-note-image": "6687"
      },
      {
        "base-note-name": "Woody Notes",
        "base-note-link":
            "https://staging19.nichegallerie.com/notes/woody-notes/",
        "base-note-image": "6860"
      }
    ];

    return Scaffold(
      bottomNavigationBar: product.stockStatus == 'instock'
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
          :

          /// If profuct is not available then show [NotifyMeCard]
          NotifyMeCard(
              isNotify: false,
              onChanged: (value) {},
            ),
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
              images: product.images,
            ),
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
                  child: AccordsBottomSheet(accordsList: accordsList),
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
                    topNotes: topNotes,
                    middleNotes: middleNotes,
                    baseNotes: baseNotes,
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
                  height: MediaQuery.of(context).size.height * 0.92,
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
                  height: MediaQuery.of(context).size.height * 0.92,
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
            SliverPadding(
              padding: const EdgeInsets.all(defaultPadding),
              sliver: SliverToBoxAdapter(
                child: Text(
                  "You may also like",
                  style: Theme.of(context).textTheme.titleSmall!,
                ),
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
            const SliverToBoxAdapter(
              child: SizedBox(height: defaultPadding),
            )
          ],
        ),
      ),
    );
  }
}
