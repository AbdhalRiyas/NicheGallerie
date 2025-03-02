import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart' hide blackColor;
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/address_model.dart';
import 'package:shop/src/repositories/user_repository.dart';
import 'package:shop/src/screens/address/views/components/address_form.dart';
import 'package:shop/src/utils/result.dart';

class AddressDialog extends StatefulWidget {
  const AddressDialog({super.key, this.addressModel});

  final AddressModel? addressModel;

  @override
  State<AddressDialog> createState() => _AddressDialogState();
}

class _AddressDialogState extends State<AddressDialog> {
  final UserRepository _userRepository = UserRepository();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postcodeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  bool _isLoading = false;
  bool _isFormValid = false;
  Map<String, dynamic> _errors = {};

  @override
  void initState() {
    if (widget.addressModel != null) {
      AddressModel address = widget.addressModel!;
      _firstNameController.text = address.firstName;
      _lastNameController.text = address.lastName;
      _companyNameController.text = address.company;
      _address1Controller.text = address.address1;
      _address2Controller.text = address.address2;
      _cityController.text = address.city;
      _postcodeController.text = address.postcode;
      _phoneController.text = address.phone;
      _emailController.text = address.email;
      _stateController.text = address.state;
      _countryController.text = address.country;
    }
    super.initState();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _formKey.currentState?.validate() ?? false;
    });
  }

  Future<void> _updateBillingAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errors.clear();
    });

    Map<String, dynamic> data = {
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'company': _companyNameController.text,
      'address_1': _address1Controller.text,
      'address_2': _address2Controller.text,
      'city': _cityController.text,
      'postcode': _postcodeController.text,
      'phone': _phoneController.text,
      'email': _emailController.text,
      'state': _stateController.text,
      'country': _countryController.text,
    };

    Result result = await _userRepository.updateBillingAddress(data);

    setState(() {
      _isLoading = false;
    });

    if (result.data != null && context.mounted) {
      toast(result.message);
      pop();
    } else if (result.errors != null) {
      setState(() {
        _errors = result.errors;
      });
    }
  }

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
            widget.addressModel == null || widget.addressModel?.firstName == ''
                ? 'Add New Address'
                : 'Edit Address',
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
              emailController: _emailController,
              validateForm: _validateForm,
              errors: _errors,
            ),
          ),
        ),
        actions: <Widget>[
          Center(
            child: ElevatedButton(
              onPressed:
                  _isLoading || !_isFormValid ? null : _updateBillingAddress,
              child:
                  _isLoading ? CircularProgressIndicator() : const Text('Save'),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      pop();
                    },
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    );
  }
}
