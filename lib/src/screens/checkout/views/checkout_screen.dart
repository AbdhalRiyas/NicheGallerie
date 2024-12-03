import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/address_model.dart';
import 'package:shop/src/screens/address/views/components/address_button.dart';
import 'package:shop/src/screens/address/views/components/address_card.dart';
import 'package:shop/src/screens/checkout/views/components/select_address_dialog.dart';
import 'package:shop/src/services/api_service.dart';

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
  AddressModel? selectedAddress;

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
                  text: selectedAddress == null
                      ? 'Select Address'
                      : 'Change Address',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SelectAddressDialog(
                          onAddressSelected: (AddressModel address) {
                            setState(() {
                              selectedAddress = address;
                            });
                          },
                        );
                      },
                    );
                  }),
              SizedBox(height: defaultPadding),
              selectedAddress != null
                  ? AddressCard(
                      title:
                          '${selectedAddress!.firstName} ${selectedAddress!.lastName}',
                      name: selectedAddress!.lastName,
                      address: selectedAddress!.address1,
                      phone: selectedAddress!.phone,
                      countryCode: selectedAddress!.country,
                      showMenu: false,
                      isSelected: true,
                    )
                  : Container(),
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
            onPressed: () async {
              if (selectedAddress == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please select address'),
                  ),
                );
                return;
              }
              if (selectedPaymentMethod == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please select payment method'),
                  ),
                );
                return;
              }
              await ApiService().post(
                ApiContants().orders,
                payload: {
                  'payment_method': "bacs",
                  'payment_method_title': "Direct Bank Transfer",
                  'set_paid': true,
                  'billing': {
                    'first_name': selectedAddress!.firstName,
                    'last_name': selectedAddress!.lastName,
                    'address_1': selectedAddress!.address1,
                    'address_2': selectedAddress!.address2,
                    'city': selectedAddress!.city,
                    'state': selectedAddress!.state,
                    'postcode': selectedAddress!.postcode,
                    'country': selectedAddress!.country,
                    'email': selectedAddress!.email,
                    'phone': selectedAddress!.phone,
                  },
                  'shipping': {
                    'first_name': selectedAddress!.firstName,
                    'last_name': selectedAddress!.lastName,
                    'address_1': selectedAddress!.address1,
                    'address_2': selectedAddress!.address2,
                    'city': selectedAddress!.city,
                    'state': selectedAddress!.state,
                    'postcode': selectedAddress!.postcode,
                    'country': selectedAddress!.country,
                  },
                  'line_items': [
                    {'product_id': 93, ' quantity': 2},
                    {'product_id': 22, 'variation_id': 23, 'quantity': 1}
                  ],
                  'shipping_lines': [
                    {
                      'method_id': "flat_rate",
                      'method_title': "Flat Rate",
                      'total': "10.00"
                    }
                  ],
                },
              );
            },
            label: const Text('Continue'),
          ),
        ),
      ),
    );
  }
}

// $request->validate([
//                 // Payment details
//                 'payment_method' => 'required|string|max:255',
//                 'payment_method_title' => 'required|string|max:255',
//                 'set_paid' => 'required|boolean',

//                 // Billing details
//                 'billing' => 'required|array',
//                 'billing.first_name' => 'required|string|max:255',
//                 'billing.last_name' => 'required|string|max:255',
//                 'billing.address_1' => 'required|string|max:255',
//                 'billing.address_2' => 'nullable|string|max:255',
//                 'billing.city' => 'required|string|max:255',
//                 'billing.state' => 'required|string|max:255',
//                 'billing.postcode' => 'required|string|max:20',
//                 'billing.country' => 'required|string|max:2', // Assuming ISO Alpha-2 format
//                 'billing.email' => 'required|email|max:255',
//                 'billing.phone' => 'required|string|max:20',

//                 // Shipping details
//                 'shipping' => 'required|array',
//                 'shipping.first_name' => 'required|string|max:255',
//                 'shipping.last_name' => 'required|string|max:255',
//                 'shipping.address_1' => 'required|string|max:255',
//                 'shipping.address_2' => 'nullable|string|max:255',
//                 'shipping.city' => 'required|string|max:255',
//                 'shipping.state' => 'required|string|max:255',
//                 'shipping.postcode' => 'required|string|max:20',
//                 'shipping.country' => 'required|string|max:2',

//                 // Line items
//                 'line_items' => 'required|array|min:1',
//                 'line_items.*.product_id' => 'required|integer',
//                 'line_items.*.variation_id' => 'nullable|integer',
//                 'line_items.*.quantity' => 'required|integer|min:1',

//                 // Shipping lines
//                 'shipping_lines' => 'required|array|min:1',
//                 'shipping_lines.*.method_id' => 'required|string|max:255',
//                 'shipping_lines.*.method_title' => 'required|string|max:255',
//                 'shipping_lines.*.total' => 'required|regex:/^\d+(\.\d{1,2})?$/', // Validates decimal format (e.g., "10.00")
//             ]);
