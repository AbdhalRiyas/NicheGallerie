import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/accord.dart';
import 'package:shop/src/models/brand.dart';
import 'package:shop/src/models/note.dart';
import 'package:shop/src/repositories/product_repository.dart';
import 'package:shop/src/screens/product/views/products_list_screen.dart';

class ExploreByScreen extends StatefulWidget {
  const ExploreByScreen({super.key, required this.taxanomy});

  final String taxanomy;

  @override
  State<ExploreByScreen> createState() => _ExploreByScreenState();
}

class _ExploreByScreenState extends State<ExploreByScreen> {
  final List<Brand> brands = [];
  final List<Accord> accords = [];
  final List<Note> notes = [];
  int _currentPage = 1;
  String? _nextPageUrl;
  bool _isLoading = false;
  bool _hasError = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchItems();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchItems() async {
    if (_isLoading || _nextPageUrl == null && _currentPage != 1) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      Map<String, dynamic> response;
      switch (widget.taxanomy) {
        case 'brands':
          response = await ProductRepository().fetchBrands();
          brands.addAll(response['items'] as List<Brand>);
          break;
        case 'accords':
          response = await ProductRepository().fetchAccords(page: _currentPage);
          accords.addAll(response['items'] as List<Accord>);
          break;
        case 'notes':
          response = await ProductRepository().fetchNotes(page: _currentPage);
          notes.addAll(response['items'] as List<Note>);
          break;
        default:
          throw Exception('Invalid taxonomy: ${widget.taxanomy}');
      }

      setState(() {
        _nextPageUrl = response['next_page_url'];
        _currentPage++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _fetchItems();
    }
  }

  List<dynamic> _getItems() {
    switch (widget.taxanomy) {
      case 'brands':
        return brands;
      case 'accords':
        return accords;
      case 'notes':
        return notes;
      default:
        return [];
    }
  }

  String _getTitle() {
    switch (widget.taxanomy) {
      case 'brands':
        return 'Brands';
      case 'accords':
        return 'Accords';
      case 'notes':
        return 'Notes';
      default:
        return 'Explore By';
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _getItems();

    if (widget.taxanomy == 'brands' && items.isNotEmpty) {
      // Group brands by first letter
      final Map<String, List<Brand>> grouped = {};
      for (final Brand brand in items) {
        final letter =
            brand.name.isNotEmpty ? brand.name[0].toUpperCase() : '#';
        grouped.putIfAbsent(letter, () => []).add(brand);
      }
      final sortedKeys = grouped.keys.toList()..sort();

      return Scaffold(
        appBar: AppBar(
          title: Text(_getTitle()),
        ),
        body: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(defaultPadding),
          itemCount: sortedKeys.length + (_isLoading ? 1 : 0),
          itemBuilder: (context, sectionIndex) {
            if (_isLoading && sectionIndex == sortedKeys.length) {
              return const Center(
                  child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator.adaptive(),
              ));
            }
            final letter = sortedKeys[sectionIndex];
            final brands = grouped[letter]!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  child: Text(
                    letter,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Divider(
                  color: greyColor.withAlpha(150),
                  thickness: 0.5,
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: brands.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: defaultPadding,
                    mainAxisSpacing: defaultPadding,
                  ),
                  itemBuilder: (context, index) {
                    final item = brands[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductsListScreen(
                              title: item.name,
                              apiEndPoint: ApiContants().products,
                              taxanomy: {"brands": item.slug},
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: greyColor.withAlpha(150),
                                width: 0.5,
                              ),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: item.imageUrl,
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
                          const SizedBox(height: 8),
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      );
    }

    // Default (accords/notes) as before
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
      ),
      body: items.isEmpty && !_isLoading
          ? Center(
              child: _hasError
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Failed to load items'),
                        TextButton(
                          onPressed: _fetchItems,
                          child: const Text('Retry'),
                        ),
                      ],
                    )
                  : const Text('No items found'),
            )
          : items.isEmpty && _isLoading
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(defaultPadding),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: defaultPadding,
                    mainAxisSpacing: defaultPadding,
                  ),
                  itemCount: items.length + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (_isLoading && index == items.length) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    final item = items[index];
                    String imageUrl = '';
                    String name = '';
                    String slug = '';
                    Map<String, String> taxonomy = {};

                    if (item is Accord) {
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

                    return GestureDetector(
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
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: primaryColor.withAlpha(150),
                                width: 0.5,
                              ),
                            ),
                            child: ClipOval(
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
                          const SizedBox(height: 8),
                          Text(
                            name.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: primaryColor,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
