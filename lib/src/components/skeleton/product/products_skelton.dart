import 'package:flutter/material.dart';
import 'package:shop/src/components/skeleton/product/product_card_skelton.dart';
import '../../../constants.dart';

class ProductsSkelton extends StatelessWidget {
  final bool isGrid;
  final int gridCount;

  const ProductsSkelton({
    super.key,
    this.isGrid = false,
    this.gridCount = 6, // default number of grid skeletons
  });

  @override
  Widget build(BuildContext context) {
    if (isGrid) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
        ),
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: defaultPadding,
            crossAxisSpacing: defaultPadding,
            childAspectRatio: 0.66,
          ),
          itemCount: gridCount,
          itemBuilder: (context, index) => const ProductCardSkelton(),
        ),
      );
    }
    // Default horizontal skeleton
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(
            left: defaultPadding,
            right: index == 4 ? defaultPadding : 0,
          ),
          child: const ProductCardSkelton(),
        ),
      ),
    );
  }
}
