import 'package:flutter/material.dart';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/repositories/category_repository.dart';
import 'package:shop/src/screens/product/views/products_list_screen.dart';
import 'package:shop/src/utils/result.dart';
import 'package:shop/src/components/skeleton/others/discover_categories_skelton.dart';

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
              padding: const EdgeInsets.fromLTRB(
                defaultPadding,
                defaultPadding,
                defaultPadding,
                defaultPadding / 2,
              ),
              child: Text(
                "Explore Categories",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
            FutureBuilder(
              future: _repository.getCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(child: DiscoverCategoriesSkelton());
                }
                if (snapshot.hasError) {
                  return const Expanded(
                    child: Center(
                      child: Text(
                        "Failed to load categories",
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  );
                }
                if (snapshot.hasData) {
                  Result result = snapshot.data!;
                  return Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding,
                        vertical: defaultPadding / 2,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.2,
                        crossAxisSpacing: defaultPadding,
                        mainAxisSpacing: defaultPadding,
                      ),
                      itemCount: result.data.length,
                      itemBuilder: (context, index) {
                        return CategoryCard(
                          title: result.data[index].name,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductsListScreen(
                                  title: result.data[index].name,
                                  categoryId: result.data[index].id.toString(),
                                  apiEndPoint: ApiContants().products,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                }
                return const Expanded(
                  child: Center(child: Text("No categories found")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          color: Theme.of(context).colorScheme.primary.withAlpha(10),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding / 2),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
