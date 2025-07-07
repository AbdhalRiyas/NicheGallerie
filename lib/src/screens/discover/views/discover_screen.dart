import 'package:flutter/material.dart';
import 'package:shop/src/components/skeleton/others/discover_categories_skelton.dart';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/repositories/category_repository.dart';
import 'package:shop/src/screens/product/views/products_list_screen.dart';
import 'package:shop/src/utils/result.dart';

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
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding,
                vertical: defaultPadding,
              ),
              child: Text(
                "Explore Categories",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      // fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                semanticsLabel: "Explore Categories",
              ),
            ),
            // Category List
            Expanded(
              child: FutureBuilder(
                future: _repository.getCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const DiscoverCategoriesSkelton();
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                          ),
                          const SizedBox(height: 8),
                          Text("Failed to load categories",
                              style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      ),
                    );
                  } else if (snapshot.hasData) {
                    Result result = snapshot.data!;
                    if (result.data.isEmpty) {
                      return const Center(
                        child: Text("No categories available"),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding),
                      itemCount: result.data.length,
                      itemBuilder: (context, index) => CategoryTile(
                        title: result.data[index].name,
                        categoryId: result.data[index].id.toString(),
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
                      ),
                    );
                  }
                  return const Center(child: Text("No data available"));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Category Tile Widget
class CategoryTile extends StatelessWidget {
  final String title;
  final String categoryId;
  final VoidCallback onTap;

  const CategoryTile({
    super.key,
    required this.title,
    required this.categoryId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withAlpha(10),
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(defaultPadding),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                  overflow: TextOverflow.ellipsis,
                  semanticsLabel: title,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
