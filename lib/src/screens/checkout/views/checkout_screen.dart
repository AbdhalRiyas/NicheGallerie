import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/config/app_config.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/address_model.dart';
import 'package:shop/src/models/currency.dart';
import 'package:shop/src/models/product.dart';
import 'package:shop/src/models/shipping_model.dart';
import 'package:shop/src/repositories/user_repository.dart';
import 'package:shop/src/screens/address/views/components/address_button.dart';
import 'package:shop/src/screens/address/views/components/address_card.dart';
import 'package:shop/src/screens/address/views/components/address_form.dart';
import 'package:shop/src/screens/checkout/views/payment_webview_screen.dart';
import 'package:shop/src/services/api_service.dart';
import 'package:shop/src/utils/currency_formatter.dart';
import 'package:shop/src/utils/result.dart';

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
  AddressModel? _selectedAddress;
  String? _selectedPaymentMethod;

  List<ShippingModel> _shippingMethods = [];
  ShippingModel? _selectedShippingMethod;

  final UserRepository _userRepository = UserRepository();
  int _currentStep = 0;

  bool _isFetchingShippingMethods = false;

  // Controllers for the address form
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _postcodeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _emailController = TextEditingController();

  // Errors map to store validation errors
  final Map<String, String> _errors = {};

  @override
  void initState() {
    _getDefaultAddress();
    super.initState();
  }

  void _fetchShippingMethods() async {
    setState(() {
      _shippingMethods.clear();
      _isFetchingShippingMethods = true;
    });

    final res = await ApiService().get(
        "${ApiContants().shippingMethods}?country=${_selectedAddress?.country}");
    if (res != null) {
      setState(() {
        _shippingMethods = res
            .map<ShippingModel>((method) => ShippingModel.fromJson(method))
            .toList();
      });
    }

    setState(() {
      _isFetchingShippingMethods = false;
    });
  }

  @override
  void dispose() {
    // Dispose all the controllers
    _firstNameController.dispose();
    _lastNameController.dispose();
    _companyNameController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _postcodeController.dispose();
    _phoneController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _getDefaultAddress() async {
    Result result = await _userRepository.getBillingAddress();
    if (result.data != null && result.data['first_name'] != '') {
      setState(() {
        _selectedAddress = AddressModel.fromJson(result.data);
      });
    }
  }

  // Validate the form
  bool _validateForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return true;
    }
    return false;
  }

  // Function to show the address edit dialog
  void _addEditAddress(AddressModel address) async {
    // Set the initial values in the controllers
    _firstNameController.text = address.firstName;
    _lastNameController.text = address.lastName;
    _companyNameController.text = address.company;
    _address1Controller.text = address.address1;
    _address2Controller.text = address.address2;
    _cityController.text = address.city;
    _postcodeController.text = address.postcode;
    _phoneController.text = address.phone;
    _stateController.text = address.state;
    _countryController.text = address.country;
    _emailController.text = address.email;

    await showDialog<Result>(
      context: context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: AddressForm(
            formKey: _formKey,
            firstNameController: _firstNameController,
            lastNameController: _lastNameController,
            companyNameController: _companyNameController,
            address1Controller: _address1Controller,
            address2Controller: _address2Controller,
            cityController: _cityController,
            postcodeController: _postcodeController,
            phoneController: _phoneController,
            stateController: _stateController,
            countryController: _countryController,
            emailController: _emailController,
            validateForm: _validateForm,
            errors: _errors,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_validateForm()) {
                // Update the selected address with the new details
                setState(() {
                  _selectedAddress = AddressModel(
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                    company: _companyNameController.text,
                    address1: _address1Controller.text,
                    address2: _address2Controller.text,
                    city: _cityController.text,
                    postcode: _postcodeController.text,
                    phone: _phoneController.text,
                    state: _stateController.text,
                    country: _countryController.text,
                    email: _emailController.text,
                  );
                });
                Navigator.of(context).pop(); // Close the dialog
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        controlsBuilder: (context, details) => Row(
          children: [
            if (_currentStep != 0)
              TextButton(
                onPressed: details.onStepCancel,
                child: const Text('Back'),
              ),
            if (_currentStep != 4)
              TextButton(
                onPressed: details.onStepContinue,
                child: const Text('Next'),
              ),
          ],
        ),
        onStepContinue: (_currentStep == 0 && _selectedAddress == null) ||
                (_currentStep == 1 && _selectedPaymentMethod == null) ||
                (_currentStep == 3 && _selectedShippingMethod == null)
            ? null
            : _onStepContinue,
        onStepCancel: _currentStep == 0 ? null : _onStepCancel,
        steps: [
          Step(
            title: const Text('Select Address'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AddressButton(
                  text: _selectedAddress == null
                      ? 'Enter Address'
                      : 'Change Address',
                  onTap: () => _addEditAddress(_selectedAddress ??
                      AddressModel(
                        firstName: '',
                        lastName: '',
                        company: '',
                        address1: '',
                        address2: '',
                        city: '',
                        state: '',
                        postcode: '',
                        country: '',
                        email: '',
                        phone: '',
                      )),
                ),
                if (_selectedAddress != null)
                  AddressCard(
                    address: _selectedAddress!,
                    onAddressScreen: false,
                  ),
              ],
            ),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Payment Method'),
            content: _buildPaymentMethods(),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Review Order'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildReviewOrder(),
              ],
            ),
            isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Shipping Method'),
            content: _isFetchingShippingMethods
                ? CircularProgressIndicator.adaptive()
                : _shippingMethods.isEmpty
                    ? Text("No shipping methods available for this address.")
                    : _buildShippinhMethods(),
            isActive: _currentStep >= 3,
            state: _currentStep > 3 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Order Summary'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderSummary(),
              ],
            ),
            isActive: _currentStep >= 4,
            state: _currentStep > 4 ? StepState.complete : StepState.indexed,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _currentStep == 4
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      _selectedPaymentMethod != null && _selectedAddress != null
                          ? _onContinuePressed
                          : null,
                  child: const Text('PLACE ORDER'),
                ),
              ),
            )
          : null,
    );
  }

  void _onStepContinue() {
    if (_currentStep < 4) {
      setState(() {
        _currentStep += 1;
      });
    }

    if (_currentStep == 3) {
      _fetchShippingMethods();
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  Widget _buildShippinhMethods() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _shippingMethods.length,
      itemBuilder: (context, index) {
        final shippingMethod = _shippingMethods[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            shippingMethod.title,
            style: TextStyle(
              color:
                  shippingMethod.methodId == _selectedShippingMethod?.methodId
                      ? blackColor
                      : greyColor,
            ),
          ),
          trailing: Icon(
            shippingMethod.methodId == _selectedShippingMethod?.methodId
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: shippingMethod.methodId == _selectedShippingMethod?.methodId
                ? primaryColor
                : Colors.grey,
          ),
          onTap: () {
            setState(() {
              _selectedShippingMethod = shippingMethod;
            });
          },
        );
      },
    );
  }

  Widget _buildPaymentMethods() {
    return Consumer<AppConfig>(
      builder: (BuildContext context, appConfig, Widget? child) {
        log(appConfig.paymentMethods.toString());
        List<Map<String, dynamic>> paymentMethods =
            appConfig.paymentMethods.where((method) {
          // Check if the method has currencies and if any of them match the specified currency code
          return method['currencies'] != null &&
              method['currencies'].any((currency) =>
                  currency['code'] ==
                  context.read<AppConfig>().preferredCurrency['code']);
        }).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (paymentMethods.isEmpty)
                ? Center(
                    child: Text('No payment methods available'),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: paymentMethods.length,
                    itemBuilder: (context, index) {
                      final paymentMethod = paymentMethods[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
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
                            _selectedPaymentMethod =
                                paymentMethod['gateway_id'];
                          });
                        },
                      );
                    },
                  ),
          ],
        );
      },
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryRow(
                'Subtotal',
                formatCurrency(
                    widget.subTotal,
                    Currency.fromJson(
                        context.read<AppConfig>().preferredCurrency))),
            SizedBox(height: 8),
            _buildSummaryRow('Shipping Fee', 'Free', color: Colors.green),
            SizedBox(height: 8),
            _buildSummaryRow('Total (Include of VAT)',
                '${context.read<AppConfig>().preferredCurrency['code']} 0'),
            SizedBox(height: 8),
            _buildSummaryRow('Estimated VAT',
                '${context.read<AppConfig>().preferredCurrency['code']} 0'),
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
    return ListView.builder(
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
                    formatCurrency(
                        product.price,
                        Currency.fromJson(
                            context.read<AppConfig>().preferredCurrency)),
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
    );
  }

  Future<void> _onContinuePressed() async {
    String result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PaymentWebViewScreen(
            checkoutUrl:
                'https://staging19.nichegallerie.com/checkout/order-pay/47005/?pay_for_order=true&key=wc_order_gI1mgHtfHJoaM')));

    print(result);
    // if (_selectedAddress == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Please select address'),
    //     ),
    //   );
    //   return;
    // }
    // if (_selectedPaymentMethod == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Please select payment method'),
    //     ),
    //   );
    //   return;
    // }
    // final res =
    //     await ApiService().post(ApiContants().calculateShipping, payload: {
    //   'payment_method': _selectedPaymentMethod,
    //   'payment_method_title': _selectedPaymentMethod,
    //   'set_paid': false,
    //   'billing': {
    //     'first_name': _selectedAddress?.firstName ?? '',
    //     'last_name': _selectedAddress?.lastName ?? '',
    //     'address_1': _selectedAddress?.address1 ?? '',
    //     'address_2': _selectedAddress?.address2 ?? '',
    //     'city': _selectedAddress?.city ?? '',
    //     'state': _selectedAddress?.state ?? '',
    //     'postcode': _selectedAddress?.postcode ?? '',
    //     'country': _selectedAddress?.country ?? '',
    //     'email': _selectedAddress?.email ?? '',
    //     'phone': _selectedAddress?.phone ?? '',
    //   },
    //   'shipping': {
    //     'first_name': _selectedAddress?.firstName ?? '',
    //     'last_name': _selectedAddress?.lastName ?? '',
    //     'address_1': _selectedAddress?.address1 ?? '',
    //     'address_2': _selectedAddress?.address2 ?? '',
    //     'city': _selectedAddress?.city ?? '',
    //     'state': _selectedAddress?.state ?? '',
    //     'postcode': _selectedAddress?.postcode ?? '',
    //     'country': _selectedAddress?.country ?? '',
    //   },
    //   'line_items': widget.cartItems
    //       .map((e) => {
    //             'product_id': e.id,
    //             'quantity': widget.productMap.firstWhere(
    //                 (element) => element['product_id'] == e.id)['qty'],
    //           })
    //       .toList(),
    //   'shipping_lines': [
    //     {
    //       'method_id': 'flat_rate',
    //       'method_title': 'Flat Rate',
    //       'total': '0',
    //     }
    //   ],
    // });
    // log(res.toString());
  }
}
