import 'package:flutter/material.dart';

class AccordProgressBar extends StatelessWidget {
  final String name;
  final double percentage;
  final String imageId;

  const AccordProgressBar({
    super.key,
    required this.name,
    required this.percentage,
    required this.imageId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          // Container(
          //   width: 40,
          //   height: 40,
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     image: DecorationImage(
          //       image: NetworkImage(
          //         'https://nichegallerie.com/wp-content/uploads/2023/04/fresh-spicy-perfume-accords-niche-gallery.jpg', // Replace with actual image URL
          //       ),
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          // const SizedBox(width: 12),
          Expanded(
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: percentage / 100,
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD2BA8B),
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
                        name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
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
    );
  }
}
