import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/components/skeleton/skeleton.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/product.dart';
import 'package:shop/src/providers/cart_provider.dart';
import 'package:shop/src/screens/checkout/views/checkout_screen.dart';
import 'package:shop/src/screens/checkout/views/components/coupon_popup.dart';

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
  initState() {
    super.initState();
    _cartProducts =
        Provider.of<CartProvider>(context, listen: false).fetchProducts();
  }

  void _onCouponCodePressed() {
    showDialog(
      context: context,
      builder: (context) {
        return CouponPopup(couponController: _couponController);
      },
    );
  }

  double calculateSubtotal(
    Map<int, Product> productMap,
    CartProvider cartProvider,
  ) {
    return cartProvider.cartItems.fold(0, (sum, cartItem) {
      final product = productMap[cartItem['product_id']];
      if (product != null) {
        return sum + product.price * cartItem['qty'];
      }
      return sum;
    });
  }

  double calculateVAT(double subtotal) {
    return subtotal * 0.00;
  }

  double calculateTotal(double subtotal, double vat) {
    return subtotal + vat;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.navigatedViaRoute
          ? AppBar(
              title: Text('Cart'),
            )
          : null,
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (!cartProvider.isBoxInitialized) {
            return _buildShimmer();
          }

          if (cartProvider.cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/icons/Empty-Cart.svg",
                    height: 100,
                    width: 100,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withValues(alpha: 0.3),
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                  Text(
                    "Uh oh! Your cart is empty",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }

          return FutureBuilder<List<Product>?>(
            future: _cartProducts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildShimmer();
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("Unable to load products"),
                );
              }

              final cartItems = snapshot.data!;

              final productMap = {
                for (var product in cartItems) product.id: product
              };

              final subtotal = calculateSubtotal(productMap, cartProvider);
              final vat = calculateVAT(subtotal);
              final total = calculateTotal(subtotal, vat);

              bool isOutOfStock = cartItems
                  .any((product) => product.stockStatus == 'outofstock');

              return Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: ListView(
                  children: [
                    Text(
                      'Review your order',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    ...List.generate(
                      cartProvider.cartItems.length,
                      (index) {
                        final cartItem = cartProvider.cartItems[index];
                        final product = productMap[cartItem['product_id']];

                        if (product == null) return const SizedBox.shrink();

                        return CartProduct(
                          key: Key(product.id.toString()),
                          product: product,
                          qty: cartItem['qty'],
                          onDecrement: () =>
                              cartProvider.decrementQty(product.id),
                          onIncrement: () =>
                              cartProvider.incrementQty(product.id),
                          onDismissed: () =>
                              cartProvider.removeItem(product.id),
                        );
                      },
                    ),
                    SizedBox(height: defaultPadding / 2),
                    Text(
                      'Your Coupon Code',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: defaultPadding),
                      child: InkWell(
                        onTap: _onCouponCodePressed,
                        child: Container(
                          padding: EdgeInsets.all(defaultPadding),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius:
                                BorderRadius.circular(defaultBorderRadius),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/Tag.svg",
                                height: 24,
                                width: 24,
                                colorFilter: ColorFilter.mode(
                                  Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color!
                                      .withValues(alpha: 0.3),
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Type coupon code',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: defaultPadding / 2),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Order Summary",
                            style: Theme.of(context).textTheme.titleMedium),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Subtotal'),
                            Text(
                              'AED ${subtotal.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: blackColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Shipping Fee'),
                            Text(
                              'Free',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total (Include of VAT)'),
                            Text(
                              'AED ${total.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: blackColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Estimated VAT'),
                            Text(
                              'AED ${vat.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: blackColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CheckoutScreen(
                                      cartItems: cartItems,
                                      productMap: cartProvider.cartItems,
                                      subTotal: calculateSubtotal(
                                        productMap,
                                        cartProvider,
                                      ),
                                    ),
                                  ),
                                );
                              },
                        child: Text(
                          'Checkout',
                        ),
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
          SizedBox(
            height: 24,
          ),
          ...List.generate(
            5,
            (index) {
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
            },
          ),
        ],
      ),
    );
  }
}
