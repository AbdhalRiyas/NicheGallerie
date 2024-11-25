import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shop/src/providers/cart_provider.dart';

final List<SingleChildWidget> providers = [
  ChangeNotifierProvider(
    create: (_) => CartProvider(),
    lazy: true,
  ),
];
