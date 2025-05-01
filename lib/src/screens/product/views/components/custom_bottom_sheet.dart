import 'package:flutter/material.dart';
import 'package:shop/src/constants.dart';

class CustomBottomSheet extends StatefulWidget {
  final RangeValues? initialRangeValues;
  final Set<String>? initialSelectedCategories;
  final String? initialSelectedSort;
  final bool? inStockOnly;
  final Function(Map<String, dynamic>)? onChanged;

  const CustomBottomSheet({
    super.key,
    this.initialRangeValues,
    this.initialSelectedCategories,
    this.initialSelectedSort,
    this.onChanged,
    this.inStockOnly,
  });

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  late RangeValues _currentRangeValues;
  late Set<String> selectedCategories;
  late String selectedSort;

  final ValueNotifier<bool> _inStockOnly = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    _inStockOnly.value = widget.inStockOnly ?? false;

    _currentRangeValues =
        widget.initialRangeValues ?? const RangeValues(99, 10000);
    selectedCategories = widget.initialSelectedCategories ?? {};
    selectedSort = widget.initialSelectedSort ?? 'Newest Arrival';
  }

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
              tabs: const [
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
                          {'label': 'Newest Arrival', 'value': 'date'},
                          {'label': 'Most Popular', 'value': 'popularity'},
                          {
                            'label': 'Price : High to Low',
                            'value': 'price_desc'
                          },
                          {
                            'label': 'Price : Low to High',
                            'value': 'price_asc'
                          },
                          {'label': 'Name : A to Z', 'value': 'title_asc'},
                          {'label': 'Name : Z to A', 'value': 'title_desc'}
                        ].map((option) => RadioListTile<String>(
                              activeColor: primaryColor,
                              title: Text(option['label']!),
                              value: option['value'].toString(),
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
                        ValueListenableBuilder(
                          valueListenable: _inStockOnly,
                          builder:
                              (BuildContext context, value, Widget? child) =>
                                  CheckboxListTile(
                            title: const Text('In stock Only'),
                            activeColor: primaryColor,
                            value: value,
                            onChanged: (bool? value) {
                              _inStockOnly.value = value!;
                              // Handle stock status change
                            },
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                        // Price Range
                        // const SizedBox(height: 16),
                        // const Text(
                        //   'Price Range',
                        //   style: TextStyle(
                        //     fontSize: 16,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        // const SizedBox(height: 8),
                        // RangeSlider(
                        //   values: _currentRangeValues,
                        //   min: 99,
                        //   max: 10000,
                        //   activeColor: Colors.brown,
                        //   inactiveColor: Colors.brown.withAlpha(50),
                        //   onChanged: (RangeValues values) {
                        //     setState(() {
                        //       _currentRangeValues = values;
                        //     });
                        //   },
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Text(
                        //       'MIN ${_currentRangeValues.start.round()}',
                        //       style: const TextStyle(color: Colors.grey),
                        //     ),
                        //     const Text(' — '),
                        //     Text(
                        //       '${_currentRangeValues.end.round()} MAX',
                        //       style: const TextStyle(color: Colors.grey),
                        //     ),
                        //   ],
                        // ),
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
                  // Trigger onChanged callback when apply button is tapped
                  if (widget.onChanged != null) {
                    widget.onChanged!({
                      'selectedSort': selectedSort,
                      'selectedCategories': selectedCategories,
                      // 'priceRange': _currentRangeValues,
                      'inStockOnly': _inStockOnly.value,
                    });
                  }
                  Navigator.pop(context, {
                    'selectedSort': selectedSort,
                    'selectedCategories': selectedCategories.toList(),
                    // 'priceRange': {
                    //   'start': _currentRangeValues.start,
                    //   'end': _currentRangeValues.end,
                    // },
                  });
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
