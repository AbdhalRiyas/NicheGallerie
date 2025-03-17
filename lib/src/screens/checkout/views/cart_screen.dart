import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/components/empty_handle_widget.dart';
import 'package:shop/src/components/skeleton/skeleton.dart';
import 'package:shop/src/config/app_config.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/currency.dart';
import 'package:shop/src/models/product.dart';
import 'package:shop/src/providers/auth_provider.dart';
import 'package:shop/src/providers/cart_provider.dart';
import 'package:shop/src/route/screen_export.dart';
import 'package:shop/src/screens/checkout/views/checkout_screen.dart';
import 'package:shop/src/screens/checkout/views/components/coupon_popup.dart';
import 'package:shop/src/utils/currency_formatter.dart';
import 'components/cart_product.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, this.navigatedViaRoute = false});

  final bool navigatedViaRoute;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();
  late Future<List<Product>?> _cartProducts;

  @override
  void initState() {
    super.initState();
    _cartProducts = Provider.of<CartProvider>(context, listen: false)
        .fetchProducts(context.read<AppConfig>().preferredCurrency['code']);
  }

  void _onCouponCodePressed() {
    showDialog(
      context: context,
      builder: (context) => CouponPopup(couponController: _couponController),
    );
  }

  double calculateSubtotal(
      Map<int, Product> productMap, CartProvider cartProvider) {
    return cartProvider.cartItems.fold(0, (sum, cartItem) {
      final product = productMap[cartItem['product_id']];
      return product != null ? sum + product.price * cartItem['qty'] : sum;
    });
  }

  double calculateVAT(double subtotal) => subtotal * 0.00;

  double calculateTotal(double subtotal, double vat) => subtotal + vat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.navigatedViaRoute ? AppBar(title: Text('Cart')) : null,
      body: Consumer2<CartProvider, AuthProvider>(
        builder: (context, cartProvider, authProvider, child) {
          if (!cartProvider.isBoxInitialized) {
            return _buildShimmer();
          }

          if (cartProvider.cartItems.isEmpty) {
            return EmptyHandleWidget(
              iconSrc: "assets/icons/Empty-Cart.svg",
              title: "Uh oh! Your cart is empty",
            );
          }

          return FutureBuilder<List<Product>?>(
            future: _cartProducts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildShimmer();
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("Unable to load products"));
              }

              final cartItems = snapshot.data!;
              final productMap = {
                for (var product in cartItems) product.id: product
              };
              final subtotal = calculateSubtotal(productMap, cartProvider);
              final isOutOfStock = cartItems
                  .any((product) => product.stockStatus == 'outofstock');

              return Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: ListView(
                  children: [
                    Text('Review your order',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: defaultPadding / 2),
                    ...cartProvider.cartItems.map((cartItem) {
                      final product = productMap[cartItem['product_id']];
                      if (product == null) return const SizedBox.shrink();

                      // if (cartItem['qty'] > product.stockQuantity) {
                      //   cartProvider.updateQty(
                      //       product.id, product.stockQuantity);
                      // }
                      return CartProduct(
                        key: Key(product.id.toString()),
                        product: product,
                        qty: cartItem['qty'],
                        onDecrement: () =>
                            cartProvider.decrementQty(product.id),
                        onIncrement: !product.manageStock ||
                                cartItem['qty'] < product.stockQuantity
                            ? () => cartProvider.incrementQty(product.id)
                            : null,
                        onDismissed: () => cartProvider.removeItem(product.id),
                      );
                    }),
                    SizedBox(height: defaultPadding / 2),
                    // Text('Your Coupon Code',
                    //     style: Theme.of(context).textTheme.titleMedium),
                    // Padding(
                    //   padding:
                    //       const EdgeInsets.symmetric(vertical: defaultPadding),
                    //   child: InkWell(
                    //     onTap: _onCouponCodePressed,
                    //     child: Container(
                    //       padding: EdgeInsets.all(defaultPadding),
                    //       decoration: BoxDecoration(
                    //         color: Colors.grey[100],
                    //         borderRadius:
                    //             BorderRadius.circular(defaultBorderRadius),
                    //       ),
                    //       child: Row(
                    //         children: [
                    //           SvgPicture.asset(
                    //             "assets/icons/Tag.svg",
                    //             height: 24,
                    //             width: 24,
                    //             colorFilter: ColorFilter.mode(
                    //               Theme.of(context)
                    //                   .textTheme
                    //                   .bodyLarge!
                    //                   .color!
                    //                   .withOpacity(0.3),
                    //               BlendMode.srcIn,
                    //             ),
                    //           ),
                    //           SizedBox(width: 8),
                    //           Text('Type coupon code'),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: defaultPadding / 2),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Order Summary",
                            style: Theme.of(context).textTheme.titleMedium),
                        SizedBox(height: defaultPadding),
                        _buildSummaryRow(
                            'Subtotal',
                            formatCurrency(
                                subtotal,
                                Currency.fromJson(context
                                    .read<AppConfig>()
                                    .preferredCurrency))),
                        SizedBox(height: 8),
                        _buildSummaryRow(
                          'Shipping Fee',
                          'Calculated at checkout',
                        ),
                        SizedBox(height: 8),
                        _buildSummaryRow('Total', 'Calculated at checkout'),
                      ],
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isOutOfStock
                            ? null
                            : () {
                                context.goNamed(checkoutScreenRoute, extra: {
                                  'cartItems': cartItems,
                                  'subTotal': subtotal,
                                  'productsMap': cartProvider.cartItems,
                                });
                              },
                        child: Text('Checkout'),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Padding _buildShimmer() {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          ...List.generate(5, (index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: defaultPadding / 2),
              child: Row(
                children: [
                  Skeleton(height: 60, width: 60),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Skeleton(height: 20, width: 300),
                        const SizedBox(height: defaultPadding / 2),
                        Skeleton(height: 20, width: 100),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Row _buildSummaryRow(String title, String value, {Color color = blackColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(
          value,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
