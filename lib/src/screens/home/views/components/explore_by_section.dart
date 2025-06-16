import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/brand.dart';
import 'package:shop/src/models/accord.dart';
import 'package:shop/src/models/note.dart';
import 'package:shop/src/screens/home/views/explore_by_screen.dart';
import 'package:shop/src/screens/product/views/products_list_screen.dart';

class ExploreBySection extends StatefulWidget {
  final Map<String, Map<String, String>>
      tabs; // Updated to include key and description
  final List<Brand> brands;
  final List<Accord> accords;
  final List<Note> notes;

  const ExploreBySection({
    super.key,
    required this.tabs,
    required this.brands,
    required this.accords,
    required this.notes,
  });

  @override
  State<ExploreBySection> createState() => _ExploreBySectionState();
}

class _ExploreBySectionState extends State<ExploreBySection> {
  late String _activeTab;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Set the initial active tab to the first tab's key
    _activeTab = widget.tabs.values.first['key']!;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onTabSelected(String tabId) {
    setState(() {
      _activeTab = tabId;
    });
  }

  List<dynamic> _getActiveItems() {
    if (_activeTab == 'brands') {
      return widget.brands;
    } else if (_activeTab == 'accords') {
      return widget.accords;
    } else if (_activeTab == 'notes') {
      return widget.notes;
    }
    return [];
  }

  String _getActiveTabTitle() {
    if (_activeTab == 'brands') {
      return "All Brands";
    } else if (_activeTab == 'accords') {
      return "All Accords";
    } else if (_activeTab == 'notes') {
      return "All Notes";
    }
    return "All";
  }

  String _getActiveTabDescription() {
    // Find the tab with the matching key and return its description
    final activeTabEntry = widget.tabs.entries.firstWhere(
      (entry) => entry.value['key'] == _activeTab,
      orElse: () => MapEntry('', {'description': ''}),
    );
    return activeTabEntry.value['description'] ?? '';
  }

  String _getActiveTaxonomy() {
    if (_activeTab == 'brands') {
      return "brands";
    } else if (_activeTab == 'accords') {
      return "accords";
    } else if (_activeTab == 'notes') {
      return "notes";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    final activeItems = _getActiveItems();
    final tabsMeta = widget.tabs.entries
        .map((e) => {'name': e.key, 'id': e.value['key']!})
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Search By",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
              ),
              const SizedBox(height: defaultPadding / 2),
              ...tabsMeta.map(
                (tab) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: defaultPadding),
                    child: SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () => _onTabSelected(tab['id']!),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _activeTab == tab['id']
                              ? Colors.black.withAlpha(200)
                              : Colors.white,
                          foregroundColor: _activeTab == tab['id']
                              ? Colors.white
                              : Colors.black.withAlpha(200),
                          elevation: _activeTab == tab['id'] ? 2 : 1,
                          padding: const EdgeInsets.symmetric(
                            vertical: defaultPadding / 2,
                          ),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: _activeTab == tab['id']
                                  ? Colors.transparent
                                  : Colors.black,
                            ),
                          ),
                        ),
                        child: Text(
                          tab['name']!.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: defaultPadding),
        Text(
          _getActiveTabDescription(),
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.black,
                fontSize: 14,
              ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: defaultPadding),
        SizedBox(
          height: 80,
          child: activeItems.isEmpty
              ? const Center(child: Text('No items found'))
              : ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: activeItems.length,
                  itemBuilder: (context, index) {
                    final item = activeItems[index];
                    String imageUrl = '';
                    String name = '';
                    String slug = '';
                    Map<String, String> taxonomy = {};

                    if (item is Brand) {
                      imageUrl = item.imageUrl;
                      name = item.name;
                      slug = item.slug;
                      taxonomy = {"brands": slug};
                    } else if (item is Accord) {
                      imageUrl = item.imageUrl;
                      name = item.name;
                      final uri = Uri.parse(item.link);
                      final segments = uri.pathSegments;
                      slug = segments.isNotEmpty
                          ? segments[segments.length - 2]
                          : '';
                      taxonomy = {"accords": slug};
                    } else if (item is Note) {
                      imageUrl = item.imageUrl;
                      name = item.name;
                      final uri = Uri.parse(item.link);
                      final segments = uri.pathSegments;
                      slug = segments.isNotEmpty
                          ? segments[segments.length - 2]
                          : '';
                      taxonomy = {"notes": slug};
                    }

                    return Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? defaultPadding : defaultPadding / 2,
                        right: defaultPadding / 2,
                      ),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductsListScreen(
                                    title: name,
                                    apiEndPoint: ApiContants().products,
                                    taxanomy: taxonomy, // Fixed typo
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(context).dividerColor,
                                  width: 1,
                                ),
                              ),
                              child: CircleAvatar(
                                child: CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator.adaptive(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        greyColor,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: 60,
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        SizedBox(
          width: 150,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(0),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExploreByScreen(
                    taxanomy: _getActiveTaxonomy(), // Fixed typo
                  ),
                ),
              );
            },
            child: Text(
              'View All ${_getActiveTabTitle().split(' ').last}'.toUpperCase(),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
