import 'package:flutter/material.dart';
import 'package:shop/src/constants.dart';
import 'banner_m.dart';

class BannerMStyle1 extends StatelessWidget {
  const BannerMStyle1({
    super.key,
    this.image =
        "https://nichegallerie.com/wp-content/uploads/2023/05/buy-niche-perfumes-fragrance-wallpaper-background-collection-nichegallerie.com_.webp",
    required this.press,
    this.ctaText,
  });
  final String? image;
  final String? ctaText;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return BannerM(
      image: image!,
      press: press,
      children: [
        if (ctaText != null)
          Positioned(
            bottom: defaultPadding,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 200,
                height: 28,
                child: ElevatedButton.icon(
                  onPressed: press,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  iconAlignment: IconAlignment.end,
                  icon: Icon(Icons.chevron_right),
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      ctaText.toString(),
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
