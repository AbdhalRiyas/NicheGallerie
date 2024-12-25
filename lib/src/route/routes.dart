import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shop/entry_point.dart';
import 'package:shop/src/config/global_key_constants.dart';
import 'package:shop/src/providers/auth_provider.dart';
import 'package:shop/src/screens/auth/views/my_account_screen.dart';

import 'screen_export.dart';

class AppRouter {
  late final GoRouter router;

  AppRouter() {
    router = GoRouter(
      navigatorKey: GlobalKeyContants().navigatorKey,
      initialLocation: '/',
      errorBuilder: (context, state) => SizedBox(),
      routes: [
        GoRoute(
          path: '/',
          name: '/',
          routes: [
            GoRoute(
              path: '$productScreenRoute/:slug',
              name: productScreenRoute,
              // redirect: (context, state) => _authCheck(context, state),
              pageBuilder: (context, state) {
                final slug = state.pathParameters['slug'] as String;
                return MaterialPage(
                  child: ProductDetailsScreen(
                    slug: slug,
                  ),
                );
              },
            ),
            GoRoute(
              path: logInScreenRoute,
              name: logInScreenRoute,
              redirect: (context, state) => _authCheck(context, state),
              pageBuilder: (context, state) {
                return const MaterialPage(
                  child: MyAccountScreen(),
                );
              },
              routes: [
                GoRoute(
                  path: 'orders',
                  name: 'orders',
                  // redirect: (context, state) => _authCheck(context, state),
                  pageBuilder: (context, state) {
                    return const MaterialPage(
                      child: OrdersScreen(),
                    );
                  },
                ),
              ],
            ),
          ],
          pageBuilder: (context, state) => MaterialPage(child: EntryPoint()),
        ),
      ],
    );
  }

  String? _authCheck(BuildContext context, GoRouterState state) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Redirect based on the authentication state
    if (!authProvider.isLoggedIn) {
      return '/my-account';
    }
    return null; // No redirection
  }
}

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:shop/entry_point.dart';
// import 'package:shop/src/config/global_key_constants.dart';

// import 'screen_export.dart';

// class AppRouter {
//   GoRouter router = GoRouter(
//     navigatorKey: GlobalKeyContants().navigatorKey,
//     initialLocation: '/',
//     errorBuilder: (context, state) => SizedBox(),
//     routes: [
//       GoRoute(
//         path: '/',
//         name: onbordingScreenRoute,
//         routes: [
//           GoRoute(
//             path: logInScreenRoute,
//             name: logInScreenRoute,
//             pageBuilder: (context, state) {
//               return const MaterialPage(
//                 child: LoginScreen(),
//               );
//             },
//           ),
//           GoRoute(
//             path: signUpScreenRoute,
//             name: signUpScreenRoute,
//             pageBuilder: (context, state) {
//               return const MaterialPage(
//                 child: SignUpScreen(),
//               );
//             },
//           ),
//           // GoRoute(
//           //   redirect: _checlogin,
//           //   path: AppRoutes.activate,
//           //   name: AppRoutes.activate,
//           //   pageBuilder: (context, state) {
//           //     return const MaterialPage(
//           //       child: ActivateScreen(),
//           //     );
//           //   },
//           // ),
//           // GoRoute(
//           //   redirect: _checlogin,
//           //   path: AppRoutes.home,
//           //   name: AppRoutes.home,
//           //   pageBuilder: (context, state) {
//           //     return MaterialPage(
//           //       child: UpgradeAlert(
//           //         child: const EntryPoint(title: AppContants.appName),
//           //       ),
//           //     );
//           //   },
//           // ),
//           // GoRoute(
//           //   redirect: _checlogin,
//           //   path: '@:username',
//           //   name: 'profile_username',
//           //   pageBuilder: (context, state) {
//           //     final username = state.pathParameters['username'] as String;
//           //     return MaterialPage(
//           //       child: ProfileScreen(
//           //         username: username,
//           //       ),
//           //     );
//           //   },
//           // ),
//           // GoRoute(
//           //   redirect: _checlogin,
//           //   path: 'u/:id',
//           //   name: 'profile_userid',
//           //   pageBuilder: (context, state) {
//           //     final int id = int.parse(state.pathParameters['id']!);
//           //     return MaterialPage(
//           //       child: ProfileScreen(
//           //         userId: id,
//           //       ),
//           //     );
//           //   },
//           // ),
//           // GoRoute(
//           //   redirect: _checlogin,
//           //   path: 'p/:id',
//           //   name: 'post',
//           //   pageBuilder: (context, state) {
//           //     final int postId = int.parse(state.pathParameters['id']!);
//           //     return MaterialPage(
//           //       child: PostScreen(
//           //         postId: postId,
//           //       ),
//           //     );
//           //   },
//           // ),
//           // GoRoute(
//           //   redirect: _checlogin,
//           //   path: 'v/:id',
//           //   name: 'video',
//           //   pageBuilder: (context, state) {
//           //     final int videoId = int.parse(state.pathParameters['id']!);
//           //     return MaterialPage(
//           //       child: VideoFeedScreen(
//           //         videoId: videoId,
//           //       ),
//           //     );
//           //   },
//           // ),
//           // GoRoute(
//           //   redirect: _checlogin,
//           //   path: AppRoutes.wallet,
//           //   name: AppRoutes.wallet,
//           //   routes: [
//           //     GoRoute(
//           //       redirect: _checlogin,
//           //       path: AppRoutes.withdrawalHistory,
//           //       name: AppRoutes.withdrawalHistory,
//           //       routes: [
//           //         GoRoute(
//           //           redirect: _checlogin,
//           //           path: AppRoutes.withdrawalDetail,
//           //           name: AppRoutes.withdrawalDetail,
//           //           pageBuilder: (context, state) {
//           //             final String id = state.uri.queryParameters['id']!;
//           //             return MaterialPage(
//           //               child: WithdrawalDetailScreen(
//           //                 id: id,
//           //               ),
//           //             );
//           //           },
//           //         ),
//           //       ],
//           //       pageBuilder: (context, state) {
//           //         return const MaterialPage(
//           //           child: WithdrawalHistory(),
//           //         );
//           //       },
//           //     ),
//           //   ],
//           //   pageBuilder: (context, state) {
//           //     return const MaterialPage(
//           //       child: WalletScreen(),
//           //     );
//           //   },
//           // ),
//           // GoRoute(
//           //   redirect: _checlogin,
//           //   path: AppRoutes.settings,
//           //   name: AppRoutes.settings,
//           //   routes: [
//           //     GoRoute(
//           //       path: AppRoutes.loggedInDevices,
//           //       name: AppRoutes.loggedInDevices,
//           //       pageBuilder: (context, state) {
//           //         return const MaterialPage(
//           //           child: LoggedInDevicesScreen(),
//           //         );
//           //       },
//           //     ),
//           //   ],
//           //   pageBuilder: (context, state) {
//           //     return const MaterialPage(child: SettingsScreen());
//           //   },
//           // ),
//         ],
//         pageBuilder: (context, state) {
//           return MaterialPage(child: LoginScreen());
//           // final appBox = Hive.box("app");

//           // return MaterialPage(
//           //   child: appBox.get("user") == null
//           //       ? const SplashScreen()
//           //       : appBox.get("user")["name"] == "Name"
//           //           ? const ActivateScreen()
//           //           : UpgradeAlert(
//           //               child: const EntryPoint(title: AppContants.appName)),
//           // );
//         },
//       ),
//     ],
//   );

//   static FutureOr<String?> _authCheck(
//       BuildContext context, GoRouterState state) {
//     final appBox = Hive.box("app");

//     if (appBox.get("user") == null) {
//       return '/auth';
//     } else if (appBox.get("user")["name"] == "Name") {
//       return '/activate';
//     } else {
//       return null;
//     }
//   }
// }
