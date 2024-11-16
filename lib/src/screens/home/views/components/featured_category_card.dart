import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeaturedCategoryCard extends StatelessWidget {
  const FeaturedCategoryCard({
    super.key,
    required this.title,
    required this.imageUrl,
    this.press,
  });

  final String title, imageUrl;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: press,
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
            ),
            Positioned.fill(
              child: Container(color: Colors.black45),
            ),
            Positioned.fill(
              top: 4,
              bottom: 4,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: IconButton(
                      onPressed: press,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.white,
                      ),
                      icon: SvgPicture.asset(
                        "assets/icons/Arrow - Right.svg",
                        fit: BoxFit.scaleDown,
                        height: 36,
                        colorFilter: const ColorFilter.mode(
                            Colors.black, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
