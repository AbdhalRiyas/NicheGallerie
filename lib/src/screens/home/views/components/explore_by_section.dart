import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shop/src/constants.dart';

class ExploreBySection extends StatefulWidget {
  const ExploreBySection({
    super.key,
  });

  @override
  State<ExploreBySection> createState() => _ExploreBySectionState();
}

class _ExploreBySectionState extends State<ExploreBySection> {
  int _activeTab = 0;
  final ScrollController _scrollController = ScrollController();
  Timer? _autoScrollTimer;

  final List _tabs = [
    {
      "id": 0,
      "name": "Brands",
      "items": [
        "https://nichegallerie.com/wp-content/uploads/2023/04/buy-tom-ford-perfume-fragrance-for-women-men-niche-gallery-nichegallerie.com_.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/buy-tom-ford-perfume-fragrance-for-women-men-niche-gallery-nichegallerie.com_.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/buy-tom-ford-perfume-fragrance-for-women-men-niche-gallery-nichegallerie.com_.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/buy-tom-ford-perfume-fragrance-for-women-men-niche-gallery-nichegallerie.com_.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/buy-tom-ford-perfume-fragrance-for-women-men-niche-gallery-nichegallerie.com_.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/buy-tom-ford-perfume-fragrance-for-women-men-niche-gallery-nichegallerie.com_.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/buy-tom-ford-perfume-fragrance-for-women-men-niche-gallery-nichegallerie.com_.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/buy-tom-ford-perfume-fragrance-for-women-men-niche-gallery-nichegallerie.com_.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/buy-tom-ford-perfume-fragrance-for-women-men-niche-gallery-nichegallerie.com_.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/buy-tom-ford-perfume-fragrance-for-women-men-niche-gallery-nichegallerie.com_.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/buy-tom-ford-perfume-fragrance-for-women-men-niche-gallery-nichegallerie.com_.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/buy-tom-ford-perfume-fragrance-for-women-men-niche-gallery-nichegallerie.com_.jpg",
      ]
    },
    {
      "id": 1,
      "name": "Accords",
      "items": [
        "https://nichegallerie.com/wp-content/uploads/2023/04/powdery-perfume-accord-buy-nichegallerie.com-perfume-niche-gallery.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/powdery-perfume-accord-buy-nichegallerie.com-perfume-niche-gallery.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/powdery-perfume-accord-buy-nichegallerie.com-perfume-niche-gallery.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/powdery-perfume-accord-buy-nichegallerie.com-perfume-niche-gallery.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/powdery-perfume-accord-buy-nichegallerie.com-perfume-niche-gallery.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/powdery-perfume-accord-buy-nichegallerie.com-perfume-niche-gallery.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/powdery-perfume-accord-buy-nichegallerie.com-perfume-niche-gallery.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/powdery-perfume-accord-buy-nichegallerie.com-perfume-niche-gallery.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/powdery-perfume-accord-buy-nichegallerie.com-perfume-niche-gallery.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/powdery-perfume-accord-buy-nichegallerie.com-perfume-niche-gallery.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/powdery-perfume-accord-buy-nichegallerie.com-perfume-niche-gallery.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/powdery-perfume-accord-buy-nichegallerie.com-perfume-niche-gallery.jpg",
      ]
    },
    {
      "id": 2,
      "name": "Notes",
      "items": [
        "https://nichegallerie.com/wp-content/uploads/2023/04/Patchouli-note-perfume-nichegallerie.com-niche-gallery-buy-perfume.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/Patchouli-note-perfume-nichegallerie.com-niche-gallery-buy-perfume.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/Patchouli-note-perfume-nichegallerie.com-niche-gallery-buy-perfume.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/Patchouli-note-perfume-nichegallerie.com-niche-gallery-buy-perfume.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/Patchouli-note-perfume-nichegallerie.com-niche-gallery-buy-perfume.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/Patchouli-note-perfume-nichegallerie.com-niche-gallery-buy-perfume.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/Patchouli-note-perfume-nichegallerie.com-niche-gallery-buy-perfume.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/Patchouli-note-perfume-nichegallerie.com-niche-gallery-buy-perfume.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/Patchouli-note-perfume-nichegallerie.com-niche-gallery-buy-perfume.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/Patchouli-note-perfume-nichegallerie.com-niche-gallery-buy-perfume.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/Patchouli-note-perfume-nichegallerie.com-niche-gallery-buy-perfume.jpg",
        "https://nichegallerie.com/wp-content/uploads/2023/04/Patchouli-note-perfume-nichegallerie.com-niche-gallery-buy-perfume.jpg",
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();

    // Add listener to the scroll controller to detect when we reach the bottom
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
    // Detect when the user reaches the end of the list
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // If the scroll reaches the end, jump back to the start
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        _scrollController.jumpTo(0);
      }
    }
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _scrollController.removeListener(_scrollListener); // Remove the listener
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: _tabs
                    .map((tab) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding / 6),
                          child: InkWell(
                            onTap: _activeTab == tab['id']
                                ? null
                                : () {
                                    setState(() {
                                      _activeTab = tab['id'];
                                    });
                                  },
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30)),
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
                                        : Theme.of(context).dividerColor),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(30)),
                              ),
                              child: Center(
                                child: Text(
                                  tab['name'],
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
        SizedBox(height: defaultPadding),
        SizedBox(
          height: 50,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount:
                null, // The list will scroll infinitely, so no fixed count
            itemBuilder: (BuildContext context, int index) {
              // Loop through the list using modulus to create an infinite scroll effect
              num itemIndex = index % _tabs[_activeTab]['items'].length;
              return Padding(
                padding: EdgeInsets.only(
                  left: defaultPadding,
                ),
                child: CachedNetworkImage(
                  imageUrl: _tabs[_activeTab]['items'][itemIndex],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
