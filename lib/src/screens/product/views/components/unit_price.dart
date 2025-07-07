import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/config/app_config.dart';
import 'package:shop/src/models/currency.dart';
import 'package:shop/src/utils/currency_formatter.dart';

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
    final currency =
        Currency.fromJson(context.read<AppConfig>().preferredCurrency);
    final theme = Theme.of(context).textTheme;

    final String mainPrice = formatCurrency(
      priceAfterDiscount ?? price,
      currency,
    );

    final String? oldPrice = priceAfterDiscount != null
        ? formatCurrency(price, currency, false)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(TextSpan(
          children: [
            if (oldPrice != null) ...[
              TextSpan(
                text: oldPrice,
                style: theme.titleSmall?.copyWith(
                  color: Colors.grey[700],
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const TextSpan(text: '    '),
            ],
            TextSpan(
              text: mainPrice,
              style: theme.titleLarge,
            ),
          ],
        )),
      ],
    );
  }
}
