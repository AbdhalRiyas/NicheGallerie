import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/config/app_config.dart';
import 'package:shop/src/models/currency.dart';
import 'package:shop/src/utils/currency_formatter.dart';

import '../constants.dart';

class CartButton extends StatelessWidget {
  const CartButton({
    super.key,
    required this.price,
    this.title = "Buy Now",
    this.subTitle,
    required this.press,
  });

  final double price;
  final String title;
  final String? subTitle;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultBorderRadius / 2),
        child: SizedBox(
          height: 64,
          child: Material(
            color: press != null ? primaryColor : Colors.grey.shade300,
            clipBehavior: Clip.hardEdge,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(defaultBorderRadius),
              ),
            ),
            child: InkWell(
              onTap: press,
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatCurrency(
                              price,
                              Currency.fromJson(
                                  context.read<AppConfig>().preferredCurrency),
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: Colors.white),
                          ),
                          if (subTitle != null)
                            Text(
                              subTitle.toString(),
                              style: const TextStyle(
                                  color: Colors.white54,
                                  fontWeight: FontWeight.w500),
                            )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      alignment: Alignment.center,
                      height: double.infinity,
                      color: Colors.black.withValues(alpha: 0.15),
                      child: Text(
                        title,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
