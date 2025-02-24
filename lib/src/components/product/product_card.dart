import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/components/custom_modal_bottom_sheet.dart';
import 'package:shop/src/config/app_contants.dart';
import 'package:shop/src/models/product.dart';
import 'package:shop/src/providers/cart_provider.dart';
import 'package:shop/src/route/screen_export.dart';
import 'package:shop/src/screens/product/views/added_to_cart_message_screen.dart';

import '../../constants.dart';
import '../network_image_with_loader.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.press,
    required this.product,
  });
  final Product product;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    double percentageOff = (product.regularPrice - product.salePrice!) /
        product.regularPrice *
        100;
    return OutlinedButton(
      onPressed: press,
      style: OutlinedButton.styleFrom(
          minimumSize: const Size(140, 220),
          maximumSize: const Size(140, 220),
          padding: const EdgeInsets.all(8)),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.25,
            child: Stack(
              children: [
                NetworkImageWithLoader(product.images.first,
                    radius: defaultBorderRadius),
                if (product.salePrice != null &&
                    product.salePrice! < product.regularPrice)
                  Positioned(
                    right: defaultPadding / 2,
                    top: defaultPadding / 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding / 2),
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
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding / 2, vertical: defaultPadding / 2),
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
                  Text(
                    product.salePrice != null
                        ? "${AppContants().currency}${product.salePrice?.toStringAsFixed(product.salePrice!.remainder(1) > 0 ? 2 : 0)}"
                        : "${AppContants().currency}${product.regularPrice.toStringAsFixed(product.regularPrice.remainder(1) > 0 ? 2 : 0)}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF2E3033),
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ),
                  if (product.salePrice != null) ...[
                    const SizedBox(width: defaultPadding / 4),
                    Text(
                      "${AppContants().currency}${product.regularPrice.toStringAsFixed(product.regularPrice.remainder(1) > 0 ? 2 : 0)}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                        fontSize: 8,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: product.stockStatus == 'instock'
                ? () {
                    try {
                      final provider =
                          Provider.of<CartProvider>(context, listen: false);
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
              padding: EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 16), // Adjust vertical padding for height
              minimumSize: Size(
                  0, 0), // Removes default minimum width and height constraints
              tapTargetSize: MaterialTapTargetSize
                  .shrinkWrap, // Reduces the button's tap area to fit its content
            ),
            child: FittedBox(
                child: Text(
              product.stockStatus == 'instock'
                  ? "Add to Cart".toUpperCase()
                  : "Out of Stock".toUpperCase(),
              style: TextStyle(fontSize: 10),
            )),
          )
        ],
      ),
    );
  }
}
