import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/components/list_tile/divider_list_tile.dart';
import 'package:shop/src/config/app_config.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/providers/auth_provider.dart';
import 'package:shop/src/route/screen_export.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'components/profile_card.dart';
import 'components/profile_menu_item_list_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppConfig>(
        builder: (context, appConfig, child) => ListView(
          children: [
            Consumer<AuthProvider>(
              builder: (BuildContext context, provider, Widget? child) =>
                  provider.isLoggedIn
                      ? ProfileCard(
                          name: provider.displayName.toString(),
                          email: provider.email.toString(),
                          imageSrc: "assets/icons/Avatar.svg",
                          isShowArrow: false,
                          // proLableText: "Sliver",
                          // isPro: true, if the user is pro
                          press: null,
                          // press: () {
                          //   Navigator.pushNamed(context, userInfoScreenRoute);
                          // },
                        )
                      : ProfileCard(
                          name: 'Login',
                          imageSrc: "assets/icons/Avatar.svg",
                          isShowHi: false,
                          press: () {
                            context.go('/$logInScreenRoute');
                          },
                        ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(
            //       horizontal: defaultPadding, vertical: defaultPadding * 1.5),
            //   child: GestureDetector(
            //     onTap: () {},
            //     child: const AspectRatio(
            //       aspectRatio: 1.8,
            //       child:
            //           NetworkImageWithLoader("https://i.imgur.com/dz0BBom.png"),
            //     ),
            //   ),
            // ),

            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding / 2),
              child: Text(
                "Account",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            const SizedBox(height: defaultPadding / 2),
            ProfileMenuListTile(
              text: "Orders",
              svgSrc: "assets/icons/Order.svg",
              press: () {
                context.go('/$ordersScreenRoute');
              },
            ),
            // ProfileMenuListTile(
            //   text: "Returns",
            //   svgSrc: "assets/icons/Return.svg",
            //   press: () {},
            // ),
            // ProfileMenuListTile(
            //   text: "Wishlist",
            //   svgSrc: "assets/icons/Wishlist.svg",
            //   press: () {},
            // ),
            ProfileMenuListTile(
              text: "Address",
              svgSrc: "assets/icons/Address.svg",
              press: () {
                context.go('/$addressScreenRoute');
              },
            ),
            // ProfileMenuListTile(
            //   text: "Payment",
            //   svgSrc: "assets/icons/card.svg",
            //   press: () {
            //     Navigator.pushNamed(context, emptyPaymentScreenRoute);
            //   },
            // ),
            // ProfileMenuListTile(
            //   text: "Wallet",
            //   svgSrc: "assets/icons/Wallet.svg",
            //   press: () {
            //     Navigator.pushNamed(context, walletScreenRoute);
            //   },
            // ),
            const SizedBox(height: defaultPadding),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding / 2),
              child: Text(
                "Personalization",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            // DividerListTileWithTrilingText(
            //   svgSrc: "assets/icons/Notification.svg",
            //   title: "Notification",
            //   trilingText: "Off",
            //   press: () {
            //     Navigator.pushNamed(context, enableNotificationScreenRoute);
            //   },
            // ),
            DividerListTileWithTrilingText(
              svgSrc: "assets/icons/Currency.svg",
              title: "Currency",
              trilingText: appConfig.preferredCurrency['code'],
              press: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: SizedBox(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: appConfig.currencies.length,
                        itemBuilder: (context, i) => ListTile(
                          title: Text(
                            appConfig.currencies[i]['code'],
                            style: TextStyle(
                              color: appConfig.currencies[i]['code'] ==
                                      appConfig.preferredCurrency['code']
                                  ? Colors.grey.shade200
                                  : null,
                            ),
                          ),
                          onTap: appConfig.currencies[i]['code'] ==
                                  appConfig.preferredCurrency
                              ? null
                              : () {
                                  appConfig.setPreferredCurrency(
                                    appConfig.currencies[i],
                                  );
                                  context.pop();
                                },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            // ProfileMenuListTile(
            //   text: "Preferences",
            //   svgSrc: "assets/icons/Preferences.svg",
            //   press: () {
            //     Navigator.pushNamed(context, preferencesScreenRoute);
            //   },
            // ),
            const SizedBox(height: defaultPadding),
            // Padding(
            //   padding: const EdgeInsets.symmetric(
            //       horizontal: defaultPadding, vertical: defaultPadding / 2),
            //   child: Text(
            //     "Settings",
            //     style: Theme.of(context).textTheme.titleSmall,
            //   ),
            // ),
            // ProfileMenuListTile(
            //   text: "Language",
            //   svgSrc: "assets/icons/Language.svg",
            //   press: () {
            //     Navigator.pushNamed(context, selectLanguageScreenRoute);
            //   },
            // ),
            // ProfileMenuListTile(
            //   text: "Location",
            //   svgSrc: "assets/icons/Location.svg",
            //   press: () {},
            // ),
            // const SizedBox(height: defaultPadding),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding / 2),
              child: Text(
                "Help & Support",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            ProfileMenuListTile(
              text: "Get Help",
              svgSrc: "assets/icons/Help.svg",
              press: () async {
                if (await canLaunchUrlString(appConfig.helpLink)) {
                  launchUrlString(
                    appConfig.helpLink,
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
            ),
            ProfileMenuListTile(
              text: "FAQ",
              svgSrc: "assets/icons/FAQ.svg",
              press: () async {
                if (await canLaunchUrlString(appConfig.faqLink)) {
                  launchUrlString(
                    appConfig.faqLink,
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
              isShowDivider: false,
            ),
            const SizedBox(height: defaultPadding),

            // Log Out
            Consumer<AuthProvider>(
              builder: (BuildContext context, provider, Widget? child) =>
                  provider.isLoggedIn
                      ? ListTile(
                          onTap: () async {
                            final shouldLogout = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    defaultBorderRadius,
                                  ),
                                ),
                                title: const Text('Confirm Logout'),
                                content: const Text(
                                    'Are you sure you want to log out?'),
                                actions: [
                                  Column(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text('Log Out'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text('Cancel'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                            if (shouldLogout == true) {
                              provider.logout();
                            }
                          },
                          minLeadingWidth: 24,
                          leading: SvgPicture.asset(
                            "assets/icons/Logout.svg",
                            height: 24,
                            width: 24,
                            colorFilter: const ColorFilter.mode(
                              errorColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          title: const Text(
                            "Log Out",
                            style: TextStyle(
                                color: errorColor, fontSize: 14, height: 1),
                          ),
                        )
                      : SizedBox(),
            )
          ],
        ),
      ),
    );
  }
}
