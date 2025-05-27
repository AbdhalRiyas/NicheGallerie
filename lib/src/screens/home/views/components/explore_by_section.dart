import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/brand.dart';
import 'package:shop/src/models/accord.dart';
import 'package:shop/src/models/note.dart';
import 'package:shop/src/repositories/category_repository.dart';
import 'package:shop/src/screens/product/views/products_list_screen.dart';

class ExploreBySection extends StatefulWidget {
  const ExploreBySection({super.key});

  @override
  State<ExploreBySection> createState() => _ExploreBySectionState();
}

class _ExploreBySectionState extends State<ExploreBySection> {
  int _activeTab = 0;
  final ScrollController _scrollController = ScrollController();
  Timer? _autoScrollTimer;

  List<Brand> _brands = [];
  List<Accord> _accords = [];
  List<Note> _notes = [];

  bool _loadingBrands = false;
  bool _loadingAccords = false;
  bool _loadingNotes = false;

  final List<Map<String, dynamic>> _tabsMeta = [
    {"id": 0, "name": "Brands"},
    {"id": 1, "name": "Accords"},
    {"id": 2, "name": "Notes"},
  ];

  @override
  void initState() {
    super.initState();
    _fetchTabData(_activeTab);
    _startAutoScroll();
    _scrollController.addListener(_scrollListener);
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (_scrollController.hasClients) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.position.pixels;
        double nextScroll = (currentScroll + 100).clamp(0, maxScroll);
        _scrollController.animateTo(nextScroll,
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      }
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchTabData(int tabId) async {
    final repo = CategoryRepository();

    if (tabId == 0 && _brands.isEmpty && !_loadingBrands) {
      setState(() => _loadingBrands = true);
      final res = await repo.getFeaturedBrands();
      setState(() {
        _brands = res.data;
        _loadingBrands = false;
      });
    } else if (tabId == 1 && _accords.isEmpty && !_loadingAccords) {
      setState(() => _loadingAccords = true);
      final res = await repo.getFeaturedAccords();
      setState(() {
        _accords = res.data;
        _loadingAccords = false;
      });
    } else if (tabId == 2 && _notes.isEmpty && !_loadingNotes) {
      setState(() => _loadingNotes = true);
      final res = await repo.getFeaturedNotes();
      setState(() {
        _notes = res.data;
        _loadingNotes = false;
      });
    }
  }

  List<dynamic> _getActiveItems() {
    switch (_activeTab) {
      case 0:
        return _brands;
      case 1:
        return _accords;
      case 2:
        return _notes;
      default:
        return [];
    }
  }

  bool _isLoadingCurrentTab() {
    switch (_activeTab) {
      case 0:
        return _loadingBrands;
      case 1:
        return _loadingAccords;
      case 2:
        return _loadingNotes;
      default:
        return false;
    }
  }

  void _onTabSelected(int tabId) {
    setState(() {
      _activeTab = tabId;
    });
    _fetchTabData(tabId);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _isLoadingCurrentTab();
    final activeItems = _getActiveItems();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Explore By", style: Theme.of(context).textTheme.titleSmall),
              Row(
                children: _tabsMeta.map((tab) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding / 6),
                    child: InkWell(
                      onTap: _activeTab == tab['id']
                          ? null
                          : () => _onTabSelected(tab['id']),
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        height: 26,
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding),
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
                            tab['name'],
                            style: const TextStyle(fontSize: 12),
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
          height: 50,
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : activeItems.isEmpty
                  ? const Center(child: Text('No items found'))
                  : ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: activeItems.length,
                      itemBuilder: (context, index) {
                        final item = activeItems[index % activeItems.length];
                        return Padding(
                          padding: const EdgeInsets.only(left: defaultPadding),
                          child: InkWell(
                            onTap: () {
                              if (item is Brand) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ProductsListScreen(
                                        title: item.name,
                                        apiEndPoint: ApiContants().products,
                                        taxanomy: {
                                          "brands": item.slug.toString(),
                                        },
                                      );
                                    },
                                  ),
                                );
                              } else if (item is Accord) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ProductsListScreen(
                                        title: item.name,
                                        apiEndPoint: ApiContants().products,
                                        taxanomy: {
                                          "accords": item.slug.toString(),
                                        },
                                      );
                                    },
                                  ),
                                );
                              } else if (item is Note) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ProductsListScreen(
                                        title: item.name,
                                        apiEndPoint: ApiContants().products,
                                        taxanomy: {
                                          "notes": item.slug.toString(),
                                        },
                                      );
                                    },
                                  ),
                                );
                              }
                            },
                            child: CachedNetworkImage(
                              imageUrl: item.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
