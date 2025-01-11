import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/screens/address/views/components/address_form.dart';

class AddressDialog extends StatefulWidget {
  const AddressDialog({super.key});

  @override
  State<AddressDialog> createState() => _AddressDialogState();
}

class _AddressDialogState extends State<AddressDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postcodeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: AlertDialog(
        insetPadding: EdgeInsets.all(defaultPadding),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
        ),
        title: Center(
          child: Text(
            'Add New Address',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: blackColor,
            ),
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
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
            ),
          ),
        ),
        actions: <Widget>[
          Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  log('Saved');
                  log(_firstNameController.text);
                  log(_lastNameController.text);
                  log(_companyNameController.text);
                  log(_address1Controller.text);
                  log(_address2Controller.text);
                  log(_cityController.text);
                  log(_postcodeController.text);
                  log(_phoneController.text);
                  log(_stateController.text);
                  log(_countryController.text);
                },
                child: const Text('Save'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
