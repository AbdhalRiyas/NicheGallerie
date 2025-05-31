import 'package:flutter/material.dart';

import '../../../../constants.dart';

class ProductAvailabilityTag extends StatelessWidget {
  const ProductAvailabilityTag({
    super.key,
    required this.isAvailable,
  });

  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    if (isAvailable) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
      padding: const EdgeInsets.all(defaultPadding / 2),
      decoration: BoxDecoration(
        color: errorColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultBorderRadius / 2),
        ),
      ),
      child: Text(
        "Currently unavailable",
        style: Theme.of(context)
            .textTheme
            .labelSmall!
            .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }
}
