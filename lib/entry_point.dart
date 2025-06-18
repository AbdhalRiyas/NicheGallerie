import 'dart:developer';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/providers/cart_provider.dart';
import 'package:shop/src/providers/product_search_provider.dart';
import 'package:shop/src/repositories/home_repository.dart';
import 'package:shop/src/route/screen_export.dart';
import 'package:shop/src/services/notification_service.dart';
import 'package:upgrader/upgrader.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  int _currentIndex = 0;

  final List _pages = [
    HomeScreen(repository: HomeRepository()),
    DiscoverScreen(),
    WishlistScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    NotificationService.instance.initialize();
    log("Notification Service Initialized");
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: PageTransitionSwitcher(
          duration: defaultDuration,
          transitionBuilder: (child, animation, secondAnimation) {
            return FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondAnimation,
              child: child,
            );
          },
          child: _pages[_currentIndex],
        ),
        bottomNavigationBar: _buildBottomNavigation(context),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: const SizedBox(),
      leadingWidth: 0,
      centerTitle: false,
      title: CachedNetworkImage(
        imageUrl:
            "https://nichegallerie.com/wp-content/uploads/2023/02/NicheGallerie.com-Main-Logo-niche-gallery-buy-best-perfume-fragrance-nichegallerie.png",
        height: 100,
        width: 180,
        fit: BoxFit.contain,
      ),
      actions: [
        IconButton(
          onPressed: () {
            final provider =
                Provider.of<ProductSearchProvider>(context, listen: false);

            provider.reset();
            context.go('/$searchScreenRoute');
          },
          icon: SvgPicture.asset(
            "assets/icons/Search.svg",
            height: 24,
            colorFilter: ColorFilter.mode(
                Theme.of(context).textTheme.bodyLarge!.color!, BlendMode.srcIn),
          ),
        ),
        // IconButton(
        //   onPressed: () {
        //     Navigator.pushNamed(context, notificationsScreenRoute);
        //   },
        //   icon: SvgPicture.asset(
        //     "assets/icons/Notification.svg",
        //     height: 24,
        //     colorFilter: ColorFilter.mode(
        //         Theme.of(context).textTheme.bodyLarge!.color!, BlendMode.srcIn),
        //   ),
        // ),
      ],
    );
  }

  Container _buildBottomNavigation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: defaultPadding / 2),
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : const Color(0xFF101015),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index != _currentIndex) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : const Color(0xFF101015),
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.transparent,
        items: [
          BottomNavigationBarItem(
            icon: svgIcon("assets/icons/Home.svg"),
            activeIcon: svgIcon("assets/icons/Home.svg", color: primaryColor),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: svgIcon("assets/icons/Category.svg"),
            activeIcon:
                svgIcon("assets/icons/Category.svg", color: primaryColor),
            label: "Discover",
          ),
          BottomNavigationBarItem(
            icon: svgIcon("assets/icons/Heart.svg"),
            activeIcon: svgIcon("assets/icons/Heart.svg", color: primaryColor),
            label: "Wishlist",
          ),
          BottomNavigationBarItem(
            icon: Consumer<CartProvider>(
              builder: (BuildContext context, CartProvider provider,
                      Widget? child) =>
                  Stack(
                clipBehavior: Clip.none,
                children: [
                  svgIcon(
                    "assets/icons/cart.svg",
                    color: _currentIndex == 3
                        ? primaryColor
                        : Theme.of(context).iconTheme.color,
                  ),
                  if (provider.cartItems.isNotEmpty)
                    Positioned(
                      top: -2,
                      right: -2,
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
                    )
                ],
              ),
            ),
            activeIcon: Consumer<CartProvider>(
              builder: (BuildContext context, CartProvider provider,
                      Widget? child) =>
                  Stack(
                clipBehavior: Clip.none,
                children: [
                  svgIcon(
                    "assets/icons/cart.svg",
                    color: primaryColor,
                  ),
                  if (provider.cartItems.isNotEmpty)
                    Positioned(
                      top: -2,
                      right: -2,
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
                    )
                ],
              ),
            ),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: svgIcon("assets/icons/Profile.svg"),
            activeIcon:
                svgIcon("assets/icons/Profile.svg", color: primaryColor),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  SvgPicture svgIcon(String src, {Color? color}) {
    return SvgPicture.asset(
      src,
      height: 24,
      colorFilter: ColorFilter.mode(
          color ??
              Theme.of(context).iconTheme.color!.withValues(
                  alpha: Theme.of(context).brightness == Brightness.dark
                      ? 0.3
                      : 1),
          BlendMode.srcIn),
    );
  }
}
