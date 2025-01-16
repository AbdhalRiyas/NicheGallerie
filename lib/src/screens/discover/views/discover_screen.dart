import 'package:flutter/material.dart';
import 'package:shop/src/components/skeleton/others/discover_categories_skelton.dart';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/repositories/category_repository.dart';
import 'package:shop/src/screens/product/views/products_list_screen.dart';
import 'package:shop/src/utils/result.dart';

import 'components/expansion_category.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final CategoryRepository _repository = CategoryRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding / 2),
              child: Text(
                "Categories",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            // While loading use 👇
            // const Expanded(
            //   child: DiscoverCategoriesSkelton(),
            // ),
            FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Result result = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: result.data.length,
                      itemBuilder: (context, index) => ExpansionCategory(
                        svgSrc: result.data[index].image,
                        //result.data[index].image?.src ??
                        title: result.data[index].name,
                        subCategory: [],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductsListScreen(
                                title: result.data[index].name,
                                apiEndPoint:
                                    '${ApiContants().products}?category=${result.data[index].id}',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
                return Expanded(child: DiscoverCategoriesSkelton());
              },
              future: _repository.getCategories(),
            )
          ],
        ),
      ),
    );
  }
}
