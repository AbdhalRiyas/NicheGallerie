import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/providers/cart_provider.dart';
import 'package:shop/src/route/route_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Import your CartProvider and svgIcon as needed

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      centerTitle: true,
      title: CachedNetworkImage(
        imageUrl:
            "https://nichegallerie.com/wp-content/uploads/2023/02/NicheGallerie.com-Main-Logo-niche-gallery-buy-best-perfume-fragrance-nichegallerie.png",
        height: 100,
        width: 180,
        fit: BoxFit.contain,
      ),
      actions: [
        Consumer<CartProvider>(
          builder:
              (BuildContext context, CartProvider provider, Widget? child) =>
                  Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/cart.svg",
                  width: 30,
                  height: 30,
                ),
                onPressed: () {
                  context.push('/$cartScreenRoute');
                },
              ),
              if (provider.cartItems.isNotEmpty)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${provider.cartItems.length}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
