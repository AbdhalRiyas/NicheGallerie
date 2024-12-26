import 'package:flutter/material.dart';
import 'package:shop/src/components/skeleton/skeleton.dart';
import 'package:shop/src/constants.dart';

class AddressCardSkelton extends StatelessWidget {
  const AddressCardSkelton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: SizedBox(
        height: 150,
        width: double.maxFinite,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(flex: 1),
              Skeleton(height: 25, width: 120),
              Spacer(flex: 1),
              Skeleton(width: 120),
              Skeleton(width: 300),
              Spacer(flex: 1),
              Skeleton(height: 20, width: 150),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
