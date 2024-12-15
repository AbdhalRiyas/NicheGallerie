import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/components/custom_snackbar.dart';
import 'package:shop/src/config/app_contants.dart';
import 'package:shop/src/models/product/product.dart';
import 'package:shop/src/providers/cart_provider.dart';

import '../../constants.dart';
import '../network_image_with_loader.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    this.dicountpercent,
    required this.press,
    required this.product,
  });
  final Product product;
  final int? dicountpercent;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: press,
      style: OutlinedButton.styleFrom(
          minimumSize: const Size(140, 220),
          maximumSize: const Size(140, 220),
          padding: const EdgeInsets.all(8)),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.15,
            child: Stack(
              children: [
                NetworkImageWithLoader(product.images.first,
                    radius: defaultBorderRadius),
                if (dicountpercent != null)
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
                        "$dicountpercent% off",
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      Text(
                        product.salePrice != null
                            ? "${AppContants().currency}${product.salePrice?.toStringAsFixed(product.salePrice!.remainder(1) > 0 ? 2 : 0)}"
                            : "${AppContants().currency}${product.regularPrice.toStringAsFixed(product.regularPrice.remainder(1) > 0 ? 2 : 0)}",
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
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                            fontSize: 8,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ]
                    ],
                  )
                ],
              ),
            ),
          ),
          product.stockStatus == 'instock'
              ? ElevatedButton(
                  onPressed: () {
                    final provider =
                        Provider.of<CartProvider>(context, listen: false);
                    provider.addItem(product.id, 1);
                    ScaffoldMessenger.of(context).showSnackBar(
                      customSnackBar('Product added to cart'),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 16), // Adjust vertical padding for height
                    minimumSize: Size(0,
                        0), // Removes default minimum width and height constraints
                    tapTargetSize: MaterialTapTargetSize
                        .shrinkWrap, // Reduces the button's tap area to fit its content
                  ),
                  child: FittedBox(
                      child: Text(
                    "Add to Cart".toUpperCase(),
                    style: TextStyle(fontSize: 10),
                  )),
                )
              : ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 16), // Adjust vertical padding for height
                    minimumSize: Size(0,
                        0), // Removes default minimum width and height constraints
                    tapTargetSize: MaterialTapTargetSize
                        .shrinkWrap, // Reduces the button's tap area to fit its content
                  ),
                  child: FittedBox(
                    child: Text(
                      "Out of Stock".toUpperCase(),
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
