import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/providers/cart_provider.dart';
import 'package:shop/src/route/route_constants.dart';
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
      title: SvgPicture.asset(
        "assets/logo/logo.svg",
        colorFilter: ColorFilter.mode(
            Theme.of(context).iconTheme.color!, BlendMode.srcIn),
        height: 30,
        width: 100,
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
                  "assets/icons/Bag.svg",
                  color: Theme.of(context).iconTheme.color,
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
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${provider.cartItems.length}',
                      style: const TextStyle(
                        color: Colors.white,
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
