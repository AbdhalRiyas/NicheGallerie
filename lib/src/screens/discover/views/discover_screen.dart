import 'package:flutter/material.dart';
import 'package:shop/src/components/skleton/others/discover_categories_skelton.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/category_model.dart';
import 'package:shop/src/repositories/category_repository.dart';
import 'package:shop/src/screens/search/views/components/search_form.dart';
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
            const Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: SearchForm(),
            ),
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
