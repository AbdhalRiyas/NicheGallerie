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
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: defaultPadding / 2),
          child: Container(
            height: 110,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .iconTheme
                  .color!
                  .withValues(alpha: 0.04 * 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Image skeleton
                Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .iconTheme
                        .color!
                        .withValues(alpha: 0.04 * 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // Text skeletons
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 16,
                          width: 120,
                          color: Theme.of(context)
                              .iconTheme
                              .color!
                              .withValues(alpha: 0.04 * 2),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 14,
                          width: 80,
                          color: Theme.of(context)
                              .iconTheme
                              .color!
                              .withValues(alpha: 0.04 * 2),
                        ),
                        const Spacer(),
                        Container(
                          height: 18,
                          width: 60,
                          color: Theme.of(context)
                              .iconTheme
                              .color!
                              .withValues(alpha: 0.04 * 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
