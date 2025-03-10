import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shop/src/providers/auth_provider.dart';
import 'package:shop/src/providers/cart_provider.dart';
import 'package:shop/src/providers/product_search_provider.dart';
import 'package:shop/src/providers/wishlist_provider.dart';
import 'package:shop/src/route/routes.dart';

final List<SingleChildWidget> providers = [
  Provider<AppRouter>(create: (_) => AppRouter()),
  ChangeNotifierProvider(create: (_) => AuthProvider()),
  ChangeNotifierProvider(
    create: (context) =>
        CartProvider(Provider.of<AuthProvider>(context, listen: false)),
    lazy: true,
  ),
  ChangeNotifierProvider(
    create: (_) => WishlistProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider(
    create: (_) => ProductSearchProvider(),
    lazy: true,
  ),
];
