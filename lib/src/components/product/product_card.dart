import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/components/custom_modal_bottom_sheet.dart';
import 'package:shop/src/components/custom_snackbar.dart';
import 'package:shop/src/config/app_config.dart';
import 'package:shop/src/models/currency.dart';
import 'package:shop/src/models/product.dart';
import 'package:shop/src/providers/cart_provider.dart';
import 'package:shop/src/providers/wishlist_provider.dart';
import 'package:shop/src/route/screen_export.dart';
import 'package:shop/src/screens/product/views/added_to_cart_message_screen.dart';
import 'package:shop/src/utils/currency_formatter.dart';

import '../../constants.dart';
import '../network_image_with_loader.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.press,
    required this.product,
    this.isListview = false,
  });
  final Product product;
  final VoidCallback press;
  final bool isListview;

  @override
  Widget build(BuildContext context) {
    double percentageOff = (product.regularPrice - product.salePrice!) /
        product.regularPrice *
        100;
    return isListview
        ? Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: InkWell(
              onTap: press,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100, // Set a fixed width for the image
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: NetworkImageWithLoader(
                        product.images.first,
                        radius: defaultBorderRadius,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            if (product.salePrice != null)
                              Text(
                                formatCurrency(
                                  product.regularPrice,
                                  Currency.fromJson(context
                                      .read<AppConfig>()
                                      .preferredCurrency),
                                  false,
                                ),
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            const SizedBox(width: 6),
                            Text(
                              formatCurrency(
                                product.salePrice ?? product.regularPrice,
                                Currency.fromJson(context
                                    .read<AppConfig>()
                                    .preferredCurrency),
                              ),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: product.stockStatus == 'instock'
                                  ? () {
                                      try {
                                        Provider.of<CartProvider>(context,
                                                listen: false)
                                            .addItem(product.id, 1);
                                        customModalBottomSheet(
                                          context,
                                          isDismissible: false,
                                          child:
                                              const AddedToCartMessageScreen(),
                                        );
                                      } catch (e) {
                                        context.go('/$logInScreenRoute');
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: defaultPadding / 2,
                                  vertical: defaultPadding / 4,
                                ),
                                minimumSize: const Size(40, 20),
                              ),
                              child: Text(
                                product.stockStatus == 'instock'
                                    ? 'Add to Cart'.toUpperCase()
                                    : 'Out Of Stock'.toUpperCase(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Consumer<WishlistProvider>(
                              builder: (context, wishlistProvider, child) {
                                bool isInWishlist = wishlistProvider
                                    .wishlistItems
                                    .contains(product.id);
                                return IconButton(
                                  icon: SvgPicture.asset(
                                    isInWishlist
                                        ? "assets/icons/Heart-Filled.svg"
                                        : "assets/icons/Heart.svg",
                                    colorFilter: isInWishlist
                                        ? const ColorFilter.mode(
                                            sandDuneColor,
                                            BlendMode.srcIn,
                                          )
                                        : const ColorFilter.mode(
                                            primaryColor,
                                            BlendMode.srcIn,
                                          ),
                                  ),
                                  onPressed: () {
                                    if (isInWishlist) {
                                      wishlistProvider.removeItem(product.id);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        customSnackBar('Removed from wishlist'),
                                      );
                                    } else {
                                      wishlistProvider.addItem(product.id);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        customSnackBar('Added to wishlist'),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : OutlinedButton(
            onPressed: press,
            style: OutlinedButton.styleFrom(
                side: BorderSide.none,
                minimumSize: const Size(140, 220),
                maximumSize: const Size(140, 220),
                padding: const EdgeInsets.all(8)),
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 1.1,
                  child: Stack(
                    children: [
                      NetworkImageWithLoader(
                        product.images.first,
                        radius: defaultBorderRadius,
                        fit: BoxFit.contain,
                      ),
                      if (product.salePrice != null &&
                          product.salePrice! < product.regularPrice)
                        Positioned(
                          left: defaultPadding / 2,
                          top: defaultPadding,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding / 3),
                            height: 16,
                            decoration: const BoxDecoration(
                              color: errorColor,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(defaultBorderRadius)),
                            ),
                            child: Text(
                              "${percentageOff.toStringAsFixed(0)}% OFF",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Consumer<WishlistProvider>(
                          builder: (context, wishlistProvider, child) {
                            bool isInWishlist = wishlistProvider.wishlistItems
                                .contains(product.id);
                            return IconButton(
                              onPressed: () {
                                if (isInWishlist) {
                                  wishlistProvider.removeItem(product.id);
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    customSnackBar('Removed from wishlist'),
                                  );
                                } else {
                                  wishlistProvider.addItem(product.id);
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    customSnackBar('Added to wishlist'),
                                  );
                                }
                              },
                              icon: SizedBox(
                                width: 24,
                                height: 24,
                                child: SvgPicture.asset(
                                  isInWishlist
                                      ? "assets/icons/Heart-Filled.svg"
                                      : "assets/icons/Heart.svg",
                                  width: 24,
                                  height: 24,
                                  colorFilter: const ColorFilter.mode(
                                    primaryColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding / 2,
                        vertical: defaultPadding / 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontSize: 12),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (product.salePrice != null) ...[
                              Text(
                                formatCurrency(
                                    product.regularPrice,
                                    Currency.fromJson(context
                                        .read<AppConfig>()
                                        .preferredCurrency),
                                    false),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color,
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: defaultPadding / 2),
                            ],
                            Text(
                              formatCurrency(
                                  product.salePrice ?? product.regularPrice,
                                  Currency.fromJson(context
                                      .read<AppConfig>()
                                      .preferredCurrency)),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF2E3033),
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: product.stockStatus == 'instock'
                      ? () {
                          try {
                            final provider = Provider.of<CartProvider>(context,
                                listen: false);
                            provider.addItem(product.id, 1);
                            customModalBottomSheet(
                              context,
                              isDismissible: false,
                              child: const AddedToCartMessageScreen(),
                            );
                          } catch (e) {
                            context.go('/$logInScreenRoute');
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.all(0), // Adjust vertical padding for height
                    // minimumSize: Size(
                    //     0, 0), // Removes default minimum width and height constraints
                    tapTargetSize: MaterialTapTargetSize
                        .shrinkWrap, // Reduces the button's tap area to fit its content
                  ),
                  child: FittedBox(
                    child: Text(
                      product.stockStatus == 'instock'
                          ? "Add to Cart".toUpperCase()
                          : "Out of Stock".toUpperCase(),
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
