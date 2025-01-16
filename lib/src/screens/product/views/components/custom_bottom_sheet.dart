import 'package:flutter/material.dart';
import 'package:shop/src/constants.dart';

class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({super.key});

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

RangeValues _currentRangeValues = const RangeValues(99, 10000);
Set<String> selectedCategories = {};
String selectedSort = '';

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Sort and Filter
      child: SizedBox(
        height:
            MediaQuery.of(context).size.height * 0.7, // Adjust height as needed
        child: Column(
          children: [
            TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: primaryColor,
              tabs: [
                Tab(text: 'Sort'),
                Tab(text: 'Filter'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Tab 1: Sort
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ...[
                          'Newest Arrival',
                          'Most Popular',
                          'Price : High to Low',
                          'Price : Low to High',
                          'Name : A to Z',
                          'Name : Z to A'
                        ].map((option) => RadioListTile(
                              activeColor: primaryColor,
                              title: Text(option),
                              value: option,
                              groupValue: selectedSort,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedSort = value!;
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                            )),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  // Tab 2: Filter
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stock Status
                        const Text(
                          'Stock Status',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CheckboxListTile(
                          title: const Text('In stock Only'),
                          activeColor: primaryColor,
                          value: false,
                          onChanged: (bool? value) {},
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                        ),

                        // Category
                        // const Text(
                        //   'Category',
                        //   style: TextStyle(
                        //     fontSize: 16,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        // ...[
                        //   'Collectible',
                        //   'Featured',
                        //   'Men',
                        //   'Unboxed',
                        //   'Unisex',
                        //   'Women'
                        // ].map((category) => CheckboxListTile(
                        //       activeColor: primaryColor,
                        //       title: Text(
                        //         category,
                        //       ),
                        //       value: selectedCategories.contains(category),
                        //       onChanged: (bool? value) {
                        //         setState(() {
                        //           if (value ?? false) {
                        //             selectedCategories.add(category);
                        //           } else {
                        //             selectedCategories.remove(category);
                        //           }
                        //         });
                        //       },
                        //       contentPadding: EdgeInsets.zero,
                        //       controlAffinity: ListTileControlAffinity.leading,
                        //     )),

                        // Dropdowns
                        // const SizedBox(height: 16),
                        ExpansionTile(
                          title: const Text('Brands'),
                          children: const [
                            // Add brand options here
                          ],
                        ),
                        ExpansionTile(
                          title: const Text('Notes'),
                          children: const [
                            // Add notes options here
                          ],
                        ),
                        ExpansionTile(
                          title: const Text('Accords'),
                          children: const [
                            // Add accords options here
                          ],
                        ),

                        // Price Range
                        const SizedBox(height: 16),
                        const Text(
                          'Price Range',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        RangeSlider(
                          values: _currentRangeValues,
                          min: 99,
                          max: 10000,
                          activeColor: Colors.brown,
                          inactiveColor: Colors.brown.withValues(alpha: 0.2),
                          onChanged: (RangeValues values) {
                            setState(() {
                              _currentRangeValues = values;
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'MIN ${_currentRangeValues.start.round()}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const Text(' — '),
                            Text(
                              '${_currentRangeValues.end.round()} MAX',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Handle apply filters
                  Navigator.pop(context);
                },
                child: const Text(
                  'APPLY',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
