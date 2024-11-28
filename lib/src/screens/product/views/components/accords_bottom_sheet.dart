import 'package:flutter/material.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/screens/product/views/components/accord_progress_bar.dart';

class AccordsBottomSheet extends StatelessWidget {
  const AccordsBottomSheet({
    super.key,
    required this.accordsList,
  });

  final List<Map<String, String>> accordsList;

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
          SizedBox(
            height: 250,
            child: ListView.builder(
              itemCount: accordsList.length,
              itemBuilder: (context, index) {
                final accord = accordsList[index];
                return AccordProgressBar(
                  name: accord['accord-name']!,
                  percentage: double.parse(accord['accord-percentage']!),
                  imageId: accord['accord-image']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
