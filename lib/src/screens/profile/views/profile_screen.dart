import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' as nb;
import 'package:provider/provider.dart';
import 'package:shop/src/components/list_tile/divider_list_tile.dart';
import 'package:shop/src/config/app_config.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/providers/auth_provider.dart';
import 'package:shop/src/repositories/user_repository.dart';
import 'package:shop/src/route/screen_export.dart';
import 'package:shop/src/screens/webview_screen.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'components/profile_card.dart';
import 'components/profile_menu_item_list_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
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
                    insetPadding: EdgeInsets.all(defaultPadding),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(defaultBorderRadius),
                    ),
                    title: Row(
                      children: [
                        Icon(
                          Icons.currency_exchange,
                          color: Theme.of(context).primaryColor,
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Select Currency',
                        ),
                      ],
                    ),
                    contentPadding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Currency list
                          Flexible(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: appConfig.currencies.length,
                              itemBuilder: (context, i) {
                                final currency = appConfig.currencies[i];
                                final isSelected = currency['code'] ==
                                    appConfig.preferredCurrency['code'];

                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        defaultBorderRadius),
                                    color: isSelected
                                        ? Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.1)
                                        : null,
                                  ),
                                  child: ListTile(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    title: Text(
                                      currency['code'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? Theme.of(context).primaryColor
                                            : null,
                                      ),
                                    ),
                                    trailing: isSelected
                                        ? Icon(
                                            Icons.check_circle,
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: 24,
                                          )
                                        : Icon(
                                            Icons.radio_button_unchecked,
                                            color: Colors.grey.shade400,
                                            size: 24,
                                          ),
                                    onTap: isSelected
                                        ? null
                                        : () {
                                            appConfig
                                                .setPreferredCurrency(currency);
                                            Navigator.of(context).pop();
                                          },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    ],
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
              text: "Contact Us",
              svgSrc: "assets/icons/Help.svg",
              press: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => WebViewScreen(
                      title: 'Contact',
                      url: appConfig.helpLink,
                      allowedUrl: appConfig.helpLink,
                    ),
                  ),
                );
              },
            ),
            ProfileMenuListTile(
              text: "FAQ",
              svgSrc: "assets/icons/FAQ.svg",
              press: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => WebViewScreen(
                      title: 'FAQs',
                      url: appConfig.faqLink,
                      allowedUrl: appConfig.faqLink,
                    ),
                  ),
                );
              },
              isShowDivider: false,
            ),
            ProfileMenuListTile(
              text: "Wholesale",
              svgSrc: "assets/icons/FAQ.svg",
              press: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => WebViewScreen(
                      title: 'Wholesale',
                      url: appConfig.wholesale,
                      allowedUrl: appConfig.wholesale,
                    ),
                  ),
                );
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
            ),
            const SizedBox(height: defaultPadding * 2),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding,
                vertical: defaultPadding / 2,
              ),
              child: Text(
                "FOLLOW US ON SOCIAL MEDIA FOR EXCLUSIVE WEEKLY GIVEAWAYS AND COUPON CODES",
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    try {
                      await launchUrlString(
                        appConfig.socialMedia['instagram']!,
                        mode: LaunchMode.externalApplication,
                      );
                    } catch (e) {
                      nb.toast(
                        'Failed to open link: ${appConfig.socialMedia['instagram']}',
                        print: true,
                      );
                    }
                  },
                  child: SvgPicture.asset(
                    "assets/icons/instagram.com.svg",
                    height: 32,
                    width: 32,
                    colorFilter: const ColorFilter.mode(
                      primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: defaultPadding),
                GestureDetector(
                  onTap: () async {
                    try {
                      await launchUrlString(
                        appConfig.socialMedia['tiktok']!,
                        mode: LaunchMode.externalApplication,
                      );
                    } catch (e) {
                      nb.toast(
                        'Failed to open link: ${appConfig.socialMedia['tiktok']}',
                        print: true,
                      );
                    }
                  },
                  child: SvgPicture.asset(
                    "assets/icons/tiktok.svg",
                    height: 32,
                    width: 32,
                    colorFilter: const ColorFilter.mode(
                      primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "SUBSCRIBE TO OUR NEWSLETTER FOR INSTANT UPDATES ON NEW ARRIVALS AND FLASH DEALS",
                    style: Theme.of(context).textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: "Your Email Address",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 0),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            // Rebuild to show/hide error
                            (context as Element).markNeedsBuild();
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 120, // Set a fixed width for the button
                        child: ElevatedButton(
                          onPressed: () async {
                            if (emailController.text.isEmpty ||
                                !RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                                ).hasMatch(emailController.text)) {
                              nb.toast(
                                'Please enter a valid email',
                                print: true,
                              );
                              return;
                            }
                            final result =
                                await UserRepository().emailSubscription(
                              emailController.text,
                            );
                            if (result.isSuccess) {
                              nb.toast(
                                'Subscribed successfully',
                                print: true,
                              );
                              emailController.clear();
                            } else {
                              nb.toast(
                                result.message,
                                print: true,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: blackColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                          child: const Text("Subscribe"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: defaultPadding),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
