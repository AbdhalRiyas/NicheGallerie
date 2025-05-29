import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/config/app_config.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/currency.dart';
import 'package:shop/src/screens/product/views/components/product_quantity.dart';
import 'package:shop/src/models/product.dart';
import 'package:shop/src/utils/currency_formatter.dart';

class CartProduct extends StatelessWidget {
  final Product product;
  final int qty;
  final VoidCallback onDismissed;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;
  final VoidCallback? onTap;

  const CartProduct({
    super.key,
    required this.product,
    required this.qty,
    required this.onDismissed,
    this.onDecrement,
    this.onIncrement,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(product.id.toString()),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: defaultPadding),
        child: SvgPicture.asset(
          'assets/icons/Delete.svg',
          height: 24,
          width: 24,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.zero,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          child: CachedNetworkImage(
            imageUrl: product.images[0],
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => Container(
              width: 60,
              height: 60,
              color: Colors.grey[200],
              child: Icon(Icons.image, color: Colors.grey),
            ),
          ),
        ),
        title: Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: product.stockStatus == 'instock'
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatCurrency(
                            product.price * qty,
                            Currency.fromJson(
                                context.read<AppConfig>().preferredCurrency)),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),
                      SizedBox(width: 8),
                      // if (product.onSale)
                      //   Text(
                      //     product.regularPrice.toStringAsFixed(2),
                      //     style: TextStyle(
                      //       color: Colors.grey,
                      //       decoration: TextDecoration.lineThrough,
                      //     ),
                      //   ),
                      Transform.scale(
                        scale: 0.7,
                        child: ProductQuantity(
                          showLabel: false,
                          numOfItem: qty,
                          onIncrement: onIncrement,
                          onDecrement: onDecrement,
                        ),
                      )
                    ],
                  ),
                ],
              )
            : Text(
                'Out of stock',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
