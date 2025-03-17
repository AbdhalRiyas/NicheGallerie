import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shop/entry_point.dart';
import 'package:shop/src/config/global_key_constants.dart';
import 'package:shop/src/providers/auth_provider.dart';
import 'package:shop/src/screens/auth/views/my_account_screen.dart';
import 'package:shop/src/screens/checkout/views/checkout_screen.dart';
import 'package:shop/src/screens/checkout/views/payment_webview_screen.dart';
import 'package:shop/src/screens/order/views/order_detail_screen.dart';
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
              pageBuilder: (context, state) {
                final slug = state.pathParameters['slug'] as String;
                return MaterialPage(
                  child: ProductDetailsScreen(slug: slug),
                );
              },
            ),
            GoRoute(
              path: searchScreenRoute,
              name: searchScreenRoute,
              pageBuilder: (context, state) {
                return const MaterialPage(child: SearchScreen());
              },
            ),
            GoRoute(
              path: cartScreenRoute,
              name: cartScreenRoute,
              // Redirect is handled here
              redirect: (context, state) => _authCheck(context, state),
              pageBuilder: (context, state) {
                return const MaterialPage(
                    child: CartScreen(navigatedViaRoute: true));
              },
            ),
            GoRoute(
              path: checkoutScreenRoute,
              name: checkoutScreenRoute,
              // Redirect is handled here
              redirect: (context, state) => _authCheck(context, state),
              pageBuilder: (context, state) {
                final args =
                    state.extra as Map<String, dynamic>?; // Extract arguments
                final cartItems = args?['cartItems'] ?? [];
                final subtotal = args?['subTotal'] ?? 0;
                final productsMap = args?['productsMap'] ?? [];

                return MaterialPage(
                    child: CheckoutScreen(
                  cartItems: cartItems,
                  subTotal: subtotal,
                  productMap: productsMap,
                ));
              },
            ),
            GoRoute(
              path: logInScreenRoute,
              name: logInScreenRoute,
              redirect: (context, state) => _authCheck(context, state),
              pageBuilder: (context, state) {
                return const MaterialPage(child: MyAccountScreen());
              },
            ),
            GoRoute(
              path: '$logInScreenRoute/orders',
              name: 'orders',
              // Redirect is handled here
              redirect: (context, state) => _authCheck(context, state),
              routes: [
                GoRoute(
                    path: 'view-order/:id',
                    name: viewOrderScreen,
                    pageBuilder: (context, state) {
                      final id = state.pathParameters['id'] as String;

                      return MaterialPage(
                        child: OrderDetailScreen(orderId: id),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'payment/:url',
                        name: paymentScreen,
                        pageBuilder: (context, state) {
                          final url = state.pathParameters['url'] as String;
                          return MaterialPage(
                            child: PaymentWebViewScreen(checkoutUrl: url),
                          );
                        },
                      ),
                    ]),
              ],
              pageBuilder: (context, state) {
                return const MaterialPage(child: OrdersScreen());
              },
            ),
            GoRoute(
              path: addressScreenRoute,
              name: addressScreenRoute,
              // Redirect is handled here
              redirect: (context, state) => _authCheck(context, state),
              pageBuilder: (context, state) {
                return const MaterialPage(child: AddressScreen());
              },
            ),
          ],
          pageBuilder: (context, state) => MaterialPage(child: EntryPoint()),
        ),
      ],
    );
  }

  // This function handles the redirect logic
  String? _authCheck(BuildContext context, GoRouterState state) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isLoggedIn) {
      return '/my-account'; // If not logged in, redirect to login screen
    }

    return null; // If logged in, no redirection needed
  }
}
