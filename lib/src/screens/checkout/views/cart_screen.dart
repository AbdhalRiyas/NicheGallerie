import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/screens/product/views/components/product_quantity.dart';

import '../../../models/product.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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
    return SingleChildScrollView(
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
            ...List.generate(products.length, (index) {
              final product = products[index];
              return Dismissible(
                key: Key(product.id.toString()),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: defaultPadding),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  setState(() {
                    products.removeAt(index);
                  });
                },
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(defaultBorderRadius),
                    child: Image.network(
                      product.images[0],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[200],
                          child: Icon(Icons.image, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  title: Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   product.shortDescription,
                      //   maxLines: 1,
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                      // SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                          ),
                          SizedBox(width: 8),
                          if (product.onSale)
                            Text(
                              '\$${product.regularPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          Transform.scale(
                            scale: 0.7,
                            child: ProductQuantity(
                              showLabel: false,
                              numOfItem: 0,
                              onIncrement: () {},
                              onDecrement: () {},
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
            Text(
              'Your coupon code',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
              child: Container(
                padding: EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(defaultBorderRadius),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Order Summary",
                    style: Theme.of(context).textTheme.titleMedium),
                SizedBox(
                  height: defaultPadding / 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal'),
                    Text('\$${calculateSubtotal().toStringAsFixed(2)}'),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Shipping Fee'),
                    Text(
                      'Free',
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total (Include of VAT)'),
                    Text('\$${calculateTotal().toStringAsFixed(2)}'),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Estimated VAT'),
                    Text('\$${calculateVAT().toStringAsFixed(2)}'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
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
