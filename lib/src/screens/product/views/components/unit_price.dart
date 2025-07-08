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

    final double displayPrice = priceAfterDiscount ?? price;

    // Get formatted amount and symbol separately
    final String formattedAmount =
        formatCurrency(displayPrice, currency, false);
    final String symbol = currency.symbol;

    // Determine symbol position
    String pos = currency.pos;
    List<InlineSpan> mainPriceSpans = [];
    TextStyle? symbolStyle = theme.titleLarge
        ?.copyWith(fontSize: (theme.titleLarge?.fontSize ?? 20) * 0.7);

    if (pos == 'left' || pos == 'left_space') {
      mainPriceSpans.add(TextSpan(
        text: symbol + (pos == 'left_space' ? ' ' : ''),
        style: symbolStyle,
      ));
      mainPriceSpans.add(TextSpan(
        text: formattedAmount,
        style: theme.titleLarge,
      ));
    } else {
      mainPriceSpans.add(TextSpan(
        text: formattedAmount,
        style: theme.titleLarge,
      ));
      mainPriceSpans.add(TextSpan(
        text: (pos == 'right_space' ? ' ' : '') + symbol,
        style: symbolStyle,
      ));
    }

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
            ...mainPriceSpans,
          ],
        )),
      ],
    );
  }
}
