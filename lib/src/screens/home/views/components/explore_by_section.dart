import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/brand.dart';
import 'package:shop/src/models/accord.dart';
import 'package:shop/src/models/note.dart';
import 'package:shop/src/screens/product/views/products_list_screen.dart';

class ExploreBySection extends StatefulWidget {
  final Map<String, String> tabs;
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
    // Set the initial active tab to the first tab's ID
    _activeTab = widget.tabs.values.first;
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

  @override
  Widget build(BuildContext context) {
    final activeItems = _getActiveItems();
    final tabsMeta =
        widget.tabs.entries.map((e) => {'name': e.key, 'id': e.value}).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Explore By",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Row(
                children: tabsMeta.map((tab) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding / 4),
                    child: InkWell(
                      onTap: _activeTab == tab['id']
                          ? null
                          : () => _onTabSelected(tab['id']!),
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding * 0.75,
                          vertical: defaultPadding / 4,
                        ),
                        decoration: BoxDecoration(
                          color: _activeTab == tab['id']
                              ? primaryColor
                              : Colors.transparent,
                          border: Border.all(
                            color: _activeTab == tab['id']
                                ? Colors.transparent
                                : Theme.of(context).dividerColor,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            tab['name']!,
                            style: TextStyle(
                              fontSize: 12,
                              color: _activeTab == tab['id']
                                  ? Colors.white
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
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
                      slug = item.slug;
                      taxonomy = {"accords": slug};
                    } else if (item is Note) {
                      imageUrl = item.imageUrl;
                      name = item.name;
                      slug = item.slug;
                      taxonomy = {"notes": slug};
                    }

                    return Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? defaultPadding : defaultPadding / 2,
                        right: index == activeItems.length - 1
                            ? defaultPadding
                            : defaultPadding / 2,
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
                                    taxanomy: taxonomy,
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
      ],
    );
  }
}
