import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../components/network_image_with_loader.dart';
import '../../../../constants.dart';
import '../../../../providers/wishlist_provider.dart';
import '../../../../components/custom_snackbar.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({
    super.key,
    required this.images,
    required this.productId,
  });

  final List<String> images;
  final int productId;

  @override
  State<ProductImages> createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  late PageController _controller;
  int _currentPage = 0;

  @override
  void initState() {
    _controller =
        PageController(viewportFraction: 0.9, initialPage: _currentPage);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Stack(
            children: [
              PageView.builder(
                controller: _controller,
                onPageChanged: (pageNum) {
                  setState(() {
                    _currentPage = pageNum;
                  });
                },
                itemCount: widget.images.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(defaultBorderRadius * 2),
                    ),
                    child: NetworkImageWithLoader(widget.images[index]),
                  ),
                ),
              ),
              // Wishlist IconButton in the top right corner
              Positioned(
                top: 12,
                right: 12,
                child: Consumer<WishlistProvider>(
                  builder: (context, wishlistProvider, child) {
                    final productId = widget.productId;
                    bool isInWishlist =
                        wishlistProvider.wishlistItems.contains(productId);
                    return IconButton(
                      onPressed: () {
                        if (isInWishlist) {
                          wishlistProvider.removeItem(productId);
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            customSnackBar('Removed from wishlist'),
                          );
                        } else {
                          wishlistProvider.addItem(productId);
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            customSnackBar('Added to wishlist'),
                          );
                        }
                      },
                      icon: SvgPicture.asset(
                        isInWishlist
                            ? "assets/icons/Heart-Filled.svg"
                            : "assets/icons/Heart.svg",
                        colorFilter: const ColorFilter.mode(
                          primaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        if (widget.images.length > 1)
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding * 0.75,
                vertical: defaultPadding * 0.5,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  widget.images.length,
                  (index) => GestureDetector(
                    onTap: () {
                      _controller.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        right: index == (widget.images.length - 1)
                            ? 0
                            : defaultPadding / 2,
                      ),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: index == _currentPage
                              ? Colors.grey.withAlpha(150)
                              : Colors.transparent,
                          width: 0.5,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(defaultBorderRadius),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(defaultBorderRadius),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            NetworkImageWithLoader(
                              widget.images[index],
                              fit: BoxFit.cover,
                            ),
                            if (index != _currentPage)
                              Container(
                                color: Colors.white.withAlpha(150),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: defaultPadding,
          ),
          child: Divider(
            color: Colors.grey.withAlpha(150),
            height: defaultPadding,
          ),
        ),
      ],
    );
  }
}
