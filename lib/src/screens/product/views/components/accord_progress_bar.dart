import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/screens/product/views/products_list_screen.dart';

class AccordProgressBar extends StatelessWidget {
  final String name;
  final double percentage;
  final String imageUrl;
  final String link;

  const AccordProgressBar({
    super.key,
    required this.name,
    required this.percentage,
    required this.imageUrl,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductsListScreen(
                title: name,
                apiEndPoint: ApiContants().products,
                taxanomy: {
                  "accords": link.split('/').length >= 2
                      ? link
                          .split('/')
                          .sublist(link.split('/').length - 2)
                          .first
                      : link
                },
              ),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: percentage / 100,
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: sandDuneColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  // Text overlay
                  Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          name.toUpperCase(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        // Text(
                        //   '${percentage.toInt()}%',
                        //   style: TextStyle(
                        //     fontSize: 12,
                        //     color:
                        //         percentage > 50 ? Colors.white70 : Colors.black54,
                        //   ),
                        // ),
                      ],
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
