import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/product.dart';
import 'package:shop/src/screens/address/views/components/address_button.dart';
import 'package:shop/src/screens/address/views/components/address_card.dart';
import 'package:shop/src/screens/checkout/views/components/select_address_dialog.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen(
      {super.key, required this.cartItems, required this.subTotal});

  final List cartItems;
  final double subTotal;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? selectedPaymentMethod;

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'title': 'Card Payment',
      'id': 'credit_card',
      'svg': 'https://www.svgrepo.com/show/328136/generic.svg',
    },
    {
      'title': 'PayPal',
      'id': 'paypal',
      'svg': 'https://www.svgrepo.com/show/328122/paypal.svg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AddressButton(
                  text: "Select Address",
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SelectAddressDialog();
                      },
                    );
                  }),
              SizedBox(height: defaultPadding),
              AddressCard(
                title: 'My home',
                name: 'Sophi Nowakowska',
                address: 'Zabiniec 12/222, 31-215 Cracow, Poland',
                phone: '+79 123 456',
                countryCode: '789',
                isSelected: false,
                showMenu: false,
              ),
              SizedBox(height: defaultPadding),
              Text(
                'Payment method',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: defaultPadding / 2),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: paymentMethods.length,
                itemBuilder: (context, index) {
                  final paymentMethod = paymentMethods[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(defaultBorderRadius),
                      ),
                      child: SvgPicture.network(
                        paymentMethod['svg'],
                        width: 24,
                        height: 24,
                      ),
                    ),
                    title: Text(
                      paymentMethod['title'],
                      style: TextStyle(
                        color: selectedPaymentMethod == paymentMethod['id']
                            ? blackColor
                            : greyColor,
                      ),
                    ),
                    trailing: Icon(
                      selectedPaymentMethod == paymentMethod['id']
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: selectedPaymentMethod == paymentMethod['id']
                          ? primaryColor
                          : Colors.grey,
                    ),
                    onTap: () {
                      setState(() {
                        selectedPaymentMethod = paymentMethod['id'];
                      });
                    },
                  );
                },
              ),
              SizedBox(height: defaultPadding),
              Text(
                'Order Summary',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: defaultPadding / 2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal'),
                      Text(
                        "AED ${widget.subTotal.toStringAsFixed(2)}",
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
                        'AED 0',
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
                        'AED 0',
                        style: TextStyle(
                          color: blackColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: defaultPadding),
              Text(
                'Review your order',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: defaultPadding / 2),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  final product = widget.cartItems[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(defaultBorderRadius),
                      child: CachedNetworkImage(
                        imageUrl: product['product'].images[0],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[200],
                          child: Icon(Icons.image, color: Colors.grey),
                        ),
                      ),
                    ),
                    title: Text(
                      product['product'].name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'AED ${product['product'].price.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor),
                            ),
                            // SizedBox(width: 8),
                            // if (product['product'].onSale)
                            //   Text(
                            //     product.regularPrice.toStringAsFixed(2),
                            //     style: TextStyle(
                            //       color: Colors.grey,
                            //       decoration: TextDecoration.lineThrough,
                            //     ),
                            //   ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Text(
                      'x${product['qty'].toString()}',
                      style: TextStyle(
                        color: blackColor60,
                        fontSize: 14,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: defaultPadding * 4),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        child: SizedBox(
          width: double.infinity,
          child: FloatingActionButton.extended(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(defaultBorderRadius),
            ),
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            onPressed: () {},
            label: const Text('Continue'),
          ),
        ),
      ),
    );
  }
}
