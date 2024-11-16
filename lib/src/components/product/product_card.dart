import 'package:flutter/material.dart';
import 'package:shop/src/config/app_contants.dart';

import '../../constants.dart';
import '../network_image_with_loader.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    this.priceAfterDiscount,
    this.dicountpercent,
    required this.press,
  });
  final String image, title;
  final double price;
  final double? priceAfterDiscount;
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
                NetworkImageWithLoader(image, radius: defaultBorderRadius),
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
                    title,
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
                        priceAfterDiscount != null
                            ? "${AppContants().currency}${priceAfterDiscount?.toStringAsFixed(priceAfterDiscount!.remainder(1) > 0 ? 2 : 0)}"
                            : "${AppContants().currency}${price.toStringAsFixed(price.remainder(1) > 0 ? 2 : 0)}",
                        style: const TextStyle(
                          color: Color(0xFF2E3033),
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                        ),
                      ),
                      if (priceAfterDiscount != null) ...[
                        const SizedBox(width: defaultPadding / 4),
                        Text(
                          "${AppContants().currency}${price.toStringAsFixed(price.remainder(1) > 0 ? 2 : 0)}",
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
          ElevatedButton(
            onPressed: () {},
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
              "Add to Cart".toUpperCase(),
              style: TextStyle(fontSize: 10),
            )),
          ),
        ],
      ),
    );
  }
}
