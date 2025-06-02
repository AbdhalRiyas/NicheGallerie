import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../skeleton.dart';

class DiscoverCategoriesSkelton extends StatelessWidget {
  const DiscoverCategoriesSkelton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      itemCount: 10,
      itemBuilder: (context, index) => const DiscoverCategorySkelton(),
    );
  }
}

class DiscoverCategorySkelton extends StatelessWidget {
  const DiscoverCategorySkelton({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      excludeSemantics: true, // Exclude skeleton from screen readers
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withAlpha(10),
          borderRadius: BorderRadius.circular(defaultBorderRadius),
        ),
        padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
        child: Container(
          padding: const EdgeInsets.all(defaultPadding),
          child: Row(
            children: [
              Expanded(
                child: Skeleton(
                  height: 20, // Match titleMedium text height
                  width: 100,
                ),
              ),
              const SizedBox(width: defaultPadding),
              Skeleton(
                height: 16, // Match arrow icon size
                width: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
