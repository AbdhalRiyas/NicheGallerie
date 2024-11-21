import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/product.dart';
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
  final List<Product> products = [
    Product(
      id: 1,
      name: 'Sleeveless Tiered Dobby Dress',
      permalink: 'sleeveless-tiered-dobby-dress',
      type: 'simple',
      shortDescription: 'Beautiful sleeveless summer dress with tiered design',
      stockStatus: 'instock',
      price: 299.43,
      regularPrice: 344.33,
      salePrice: 299.43,
      onSale: true,
      images: [
        'https://example.com/dress1.jpg',
        'https://example.com/dress1-2.jpg'
      ],
    ),
    Product(
      id: 2,
      name: 'Printed Sleeveless Tiered Dress',
      permalink: 'printed-sleeveless-tiered-dress',
      type: 'simple',
      shortDescription: 'Elegant printed sleeveless dress with tiered pattern',
      stockStatus: 'instock',
      price: 299.43,
      regularPrice: 344.33,
      salePrice: 299.43,
      onSale: true,
      images: [
        'https://example.com/dress2.jpg',
        'https://example.com/dress2-2.jpg'
      ],
    ),
    Product(
      id: 3,
      name: 'Floral Sleeveless Tiered Dress',
      permalink: 'floral-sleeveless-tiered-dress',
      type: 'simple',
      shortDescription: 'Stylish floral sleeveless dress with tiered pattern',
      stockStatus: 'instock',
      price: 299.43,
      regularPrice: 344.33,
      salePrice: 299.43,
      onSale: true,
      images: [
        'https://example.com/dress3.jpg',
        'https://example.com/dress3-2.jpg'
      ],
    ),
    Product(
      id: 4,
      name: 'Floral Sleeveless Tiered Dress',
      permalink: 'floral-sleeveless-tiered-dress',
      type: 'simple',
      shortDescription: 'Stylish floral sleeveless dress with tiered pattern',
      stockStatus: 'instock',
      price: 299.43,
      regularPrice: 344.33,
      salePrice: 299.43,
      onSale: true,
      images: [
        'https://example.com/dress3.jpg',
        'https://example.com/dress3-2.jpg'
      ],
    ),
    Product(
      id: 5,
      name: 'Floral Sleeveless Tiered Dress',
      permalink: 'floral-sleeveless-tiered-dress',
      type: 'simple',
      shortDescription: 'Stylish floral sleeveless dress with tiered pattern',
      stockStatus: 'instock',
      price: 299.43,
      regularPrice: 344.33,
      salePrice: 299.43,
      onSale: true,
      images: [
        'https://example.com/dress3.jpg',
        'https://example.com/dress3-2.jpg'
      ],
    )
  ];

  void _onCouponCodePressed() {
    showDialog(
      context: context,
      builder: (context) {
        return CouponPopup(couponController: _couponController);
      },
    );
  }

  double calculateSubtotal() {
    return products.fold(0, (sum, product) => sum + product.price);
  }

  double calculateVAT() {
    return calculateSubtotal() * 0.05; // Assuming 5% VAT
  }

  double calculateTotal() {
    return calculateSubtotal() + calculateVAT();
  }

  @override
  Widget build(BuildContext context) {
    return products.isEmpty
        ? Center(
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
              SizedBox(height: defaultPadding),
              Text(
                "Uh oh! Your cart is empty",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ))
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Review your order',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: defaultPadding / 2),
                  ...List.generate(
                    products.length,
                    (index) => CartProduct(
                      key: Key(products[index].id.toString()),
                      product: products[index],
                      onDismissed: () {
                        setState(() {
                          products.removeAt(index);
                        });
                      },
                    ),
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
                            '\$${calculateSubtotal().toStringAsFixed(2)}',
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
                            '\$${calculateTotal().toStringAsFixed(2)}',
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
                            '\$${calculateVAT().toStringAsFixed(2)}',
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
                                builder: (context) => CheckoutScreen()));
                      },
                      child: Text(
                        'Checkout',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
