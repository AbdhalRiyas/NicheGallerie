import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/screens/product/views/components/accord_progress_bar.dart';

class AccordsBottomSheet extends StatelessWidget {
  const AccordsBottomSheet({
    super.key,
    required this.accordsList,
  });

  final List<dynamic> accordsList;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'MAIN ACCORDS',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: defaultPadding),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: accordsList.length,
              itemBuilder: (context, index) {
                final accord = accordsList[index];
                log('Accord: ${accord['accord_name']}, Percentage: ${accord['accord_percentage']}, Image URL: ${accord['image_url']}');
                return AccordProgressBar(
                  name: accord['accord_name']!,
                  percentage: double.parse(accord['accord_percentage']!),
                  imageUrl: accord['image_url']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
