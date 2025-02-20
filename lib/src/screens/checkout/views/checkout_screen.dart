import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/config/app_config.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/address_model.dart';
import 'package:shop/src/models/product.dart';
import 'package:shop/src/screens/address/views/components/address_button.dart';
import 'package:shop/src/screens/address/views/components/address_card.dart';
import 'package:shop/src/screens/checkout/views/components/select_address_dialog.dart';
import 'package:shop/src/services/api_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen(
      {super.key,
      required this.cartItems,
      required this.subTotal,
      required this.productMap});

  final List cartItems;
  final List<Map<dynamic, dynamic>> productMap;
  final double subTotal;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? _selectedPaymentMethod;
  AddressModel? _selectedAddress;

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
                text: _selectedAddress == null
                    ? 'Select Address'
                    : 'Change Address',
                onTap: () => _showSelectAddressDialog(context),
              ),
              SizedBox(height: defaultPadding),
              if (_selectedAddress != null)
                AddressCard(
                  title:
                      '${_selectedAddress!.firstName} ${_selectedAddress!.lastName}',
                  name: _selectedAddress!.lastName,
                  address: _selectedAddress!.address1,
                  phone: _selectedAddress!.phone,
                  countryCode: _selectedAddress!.country,
                  showMenu: false,
                  isSelected: true,
                ),
              SizedBox(height: defaultPadding),
              _buildPaymentMethods(),
              SizedBox(height: defaultPadding),
              _buildOrderSummary(),
              SizedBox(height: defaultPadding),
              _buildReviewOrder(),
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
          child: ElevatedButton(
            onPressed:
                _selectedPaymentMethod != null && _selectedAddress != null
                    ? _onContinuePressed
                    : null,
            child: const Text('Continue'),
          ),
        ),
      ),
    );
  }

  void _showSelectAddressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SelectAddressDialog(
          onAddressSelected: (AddressModel address) {
            setState(() {
              _selectedAddress = address;
            });
          },
        );
      },
    );
  }

  Widget _buildPaymentMethods() {
    return Consumer<AppConfig>(
      builder: (BuildContext context, appConfig, Widget? child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment method',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: defaultPadding / 2),
          (appConfig.paymentMethods.isEmpty)
              ? Center(
                  child: Text('No payment methods available'),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: appConfig.paymentMethods.length,
                  itemBuilder: (context, index) {
                    final paymentMethod = appConfig.paymentMethods[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      // leading: Container(
                      //   width: 40,
                      //   height: 40,
                      //   decoration: BoxDecoration(
                      //     borderRadius:
                      //         BorderRadius.circular(defaultBorderRadius),
                      //   ),
                      //   child: SvgPicture.network(
                      //     paymentMethod['svg'],
                      //     width: 24,
                      //     height: 24,
                      //   ),
                      // ),
                      title: Text(
                        paymentMethod['title'],
                        style: TextStyle(
                          color: _selectedPaymentMethod ==
                                  paymentMethod['gateway_id']
                              ? blackColor
                              : greyColor,
                        ),
                      ),
                      trailing: Icon(
                        _selectedPaymentMethod == paymentMethod['gateway_id']
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: _selectedPaymentMethod ==
                                paymentMethod['gateway_id']
                            ? primaryColor
                            : Colors.grey,
                      ),
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = paymentMethod['gateway_id'];
                        });
                      },
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Summary',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: defaultPadding / 2),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryRow(
                'Subtotal', "AED ${widget.subTotal.toStringAsFixed(2)}"),
            SizedBox(height: 8),
            _buildSummaryRow('Shipping Fee', 'Free', color: Colors.green),
            SizedBox(height: 8),
            _buildSummaryRow('Total (Include of VAT)', 'AED 0'),
            SizedBox(height: 8),
            _buildSummaryRow('Estimated VAT', 'AED 0'),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String title, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(
          value,
          style: TextStyle(
            color: color ?? blackColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildReviewOrder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            final Product product = widget.cartItems[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(defaultBorderRadius),
                child: CachedNetworkImage(
                  imageUrl: product.images[0],
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
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'AED ${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: Text(
                'x${widget.productMap[index]['qty'].toString()}',
                style: TextStyle(
                  color: blackColor60,
                  fontSize: 14,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _onContinuePressed() async {
    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select address'),
        ),
      );
      return;
    }
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select payment method'),
        ),
      );
      return;
    }
    final res = await ApiService().post(ApiContants().orders, payload: {
      'payment_method': _selectedPaymentMethod,
      'payment_method_title': _selectedPaymentMethod,
      'set_paid': false,
      'billing': {
        'first_name': _selectedAddress!.firstName,
        'last_name': _selectedAddress!.lastName,
        'address_1': _selectedAddress!.address1,
        'address_2': _selectedAddress!.address2,
        'city': _selectedAddress!.city,
        'state': _selectedAddress!.state,
        'postcode': _selectedAddress!.postcode,
        'country': _selectedAddress!.country,
        'email': 'demo@demo.com',
        'phone': _selectedAddress!.phone,
      },
      'shipping': {
        'first_name': _selectedAddress!.firstName,
        'last_name': _selectedAddress!.lastName,
        'address_1': _selectedAddress!.address1,
        'address_2': _selectedAddress!.address2,
        'city': _selectedAddress!.city,
        'state': _selectedAddress!.state,
        'postcode': _selectedAddress!.postcode,
        'country': _selectedAddress!.country,
      },
      'line_items': widget.cartItems
          .map((e) => {
                'product_id': e.id,
                'quantity': widget.productMap.firstWhere(
                    (element) => element['product_id'] == e.id)['qty'],
              })
          .toList(),
      'shipping_lines': [
        {
          'method_id': 'flat_rate',
          'method_title': 'Flat Rate',
          'total': '0',
        }
      ],
    });
    log(res.toString());
  }
}
