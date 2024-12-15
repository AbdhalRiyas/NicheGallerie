import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/product/product.dart';
import 'package:shop/src/providers/cart_provider.dart';
import 'package:shop/src/screens/checkout/views/checkout_screen.dart';
import 'package:shop/src/screens/checkout/views/components/coupon_popup.dart';

import 'components/cart_product.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();

  void _onCouponCodePressed() {
    showDialog(
      context: context,
      builder: (context) {
        return CouponPopup(couponController: _couponController);
      },
    );
  }

  double calculateSubtotal() {
    return 0;
    // return products.fold(0, (sum, product) => sum + product.price);
  }

  double calculateVAT() {
    return calculateSubtotal() * 0.05; // Assuming 5% VAT
  }

  double calculateTotal() {
    return calculateSubtotal() + calculateVAT();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        if (!cartProvider.isBoxInitialized) {
          return const Center(child: CircularProgressIndicator());
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
                        .withOpacity(0.3),
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
            future: cartProvider.fetchProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("Unable to load products"),
                );
              }

              final products = snapshot.data!;

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
                        final product = products.firstWhere(
                          (p) => p.id == cartItem['product_id'],
                          // orElse: () => Product(

                          //   id: cartItem['product_id'],
                          //   name: 'Unknown Product',
                          //   price: 0.0,
                          // ),
                        );

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
                                      .withOpacity(0.3),
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
                              'AED ${calculateSubtotal().toStringAsFixed(2)}',
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
                              'AED ${calculateTotal().toStringAsFixed(2)}',
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
                              'AED ${calculateVAT().toStringAsFixed(2)}',
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutScreen(
                                cartItems: cartProvider.cartItems,
                                subTotal: calculateSubtotal(),
                                // subTotal: cartProvider.calculateSubTotal(),
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
            });
      },
    );
  }
}
