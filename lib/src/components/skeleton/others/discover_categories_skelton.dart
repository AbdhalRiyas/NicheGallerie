import 'package:flutter/material.dart';
import 'package:shop/src/components/skeleton/skeleton.dart';
import 'package:shop/src/constants.dart';

class DiscoverCategoriesSkelton extends StatelessWidget {
  const DiscoverCategoriesSkelton({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
      ),
      itemCount: 8, // Display 8 skeleton items to simulate loading
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: const Padding(
          padding: EdgeInsets.all(defaultPadding / 2),
          child: Skeleton(
            height: double.infinity,
            width: double.infinity,
            radious: 8,
          ),
        ),
      ),
    );
  }
}
