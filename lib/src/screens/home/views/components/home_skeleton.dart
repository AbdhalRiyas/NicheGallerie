import 'package:flutter/material.dart';
import 'package:shop/src/components/skeleton/product/products_skelton.dart';
import 'package:shop/src/components/skeleton/skeleton.dart';
import 'package:shop/src/constants.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.all(defaultPadding / 2),
          child: Skeleton(
            height: 200,
            width: double.infinity,
          ),
        ),
        SizedBox(
          height: 40,
        ),
        ProductsSkelton(
          isGrid: true,
          gridCount: 4,
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              3,
              (index) => Skeleton(
                height: 150,
                width: (MediaQuery.of(context).size.width -
                        (defaultPadding * 2 + 20)) /
                    3,
              ),
            ),
          ),
        )
      ],
    );
  }
}
