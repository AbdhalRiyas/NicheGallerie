import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/config/app_config.dart';
import 'package:shop/src/models/currency.dart';
import 'package:shop/src/utils/currency_formatter.dart';

import '../../../../constants.dart';

class UnitPrice extends StatelessWidget {
  const UnitPrice({
    super.key,
    required this.price,
    this.priceAfterDiscount,
  });

  final double price;
  final double? priceAfterDiscount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Price",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: defaultPadding / 1),
        Text.rich(
          TextSpan(
            text: priceAfterDiscount == null
                ? formatCurrency(
                    price,
                    Currency.fromJson(
                        context.read<AppConfig>().preferredCurrency),
                  )
                : formatCurrency(
                    priceAfterDiscount!,
                    Currency.fromJson(
                        context.read<AppConfig>().preferredCurrency),
                  ),
            style: Theme.of(context).textTheme.titleLarge,
            children: [
              if (priceAfterDiscount != null) ...[
                TextSpan(
                  text:
                      '  ${formatCurrency(price, Currency.fromJson(context.read<AppConfig>().preferredCurrency), false)}',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                      decoration: TextDecoration.lineThrough),
                ),
              ]
            ],
          ),
        )
      ],
    );
  }
}
