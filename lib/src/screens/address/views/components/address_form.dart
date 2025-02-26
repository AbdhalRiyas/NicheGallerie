import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/screens/address/views/components/country_state_picker.dart';
import 'package:shop/src/screens/address/views/components/form_field_svg_icon.dart';

class AddressForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController companyNameController;
  final TextEditingController address1Controller;
  final TextEditingController address2Controller;
  final TextEditingController cityController;
  final TextEditingController postcodeController;
  final TextEditingController phoneController;
  final TextEditingController stateController;
  final TextEditingController countryController;

  const AddressForm({
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.companyNameController,
    required this.address1Controller,
    required this.address2Controller,
    required this.cityController,
    required this.postcodeController,
    required this.phoneController,
    required this.stateController,
    required this.countryController,
    super.key,
  });

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    widget.firstNameController.addListener(_validateForm);
    widget.lastNameController.addListener(_validateForm);
    widget.address1Controller.addListener(_validateForm);
    widget.cityController.addListener(_validateForm);
    widget.postcodeController.addListener(_validateForm);
    widget.phoneController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      isFormValid = widget.formKey.currentState?.validate() ?? false;
    });
  }

  String? nameValidator(String? value) {
    if (value == null ||
        value.isEmpty ||
        value.length < 3 ||
        value.length > 20) {
      return 'Enter valid name';
    }
    return null;
  }

  String? address1Validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address is required';
    }
    return null;
  }

  String? cityValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'City is required';
    }
    return null;
  }

  String? postCodeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Postcode is required';
    }
    return null;
  }

  String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.firstNameController,
                  onSaved: (fName) {},
                  validator: (value) => nameValidator(value),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z]'),
                    ),
                  ],
                  decoration: InputDecoration(
                      hintText: "First name",
                      prefixIcon: FormFieldSvgIcon(
                        iconPath: "assets/icons/Profile.svg",
                      )),
                ),
              ),
              const SizedBox(width: defaultPadding),
              Expanded(
                child: TextFormField(
                  controller: widget.lastNameController,
                  onSaved: (lName) {
                    // Last Name
                  },
                  validator: (value) => nameValidator(value),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z]'),
                    ),
                  ],
                  decoration: InputDecoration(
                    hintText: "Last name",
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            controller: widget.companyNameController,
            onSaved: (companyName) {
              // Company Name
            },
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            inputFormatters: [],
            decoration: InputDecoration(
              hintText: "Company name (optional)",
              prefixIcon: FormFieldSvgIcon(
                iconPath: "assets/icons/Company.svg",
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          CountryStatePicker(
            stateController: widget.stateController,
            countryController: widget.countryController,
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            controller: widget.address1Controller,
            onSaved: (address1) {
              // House number and street name
            },
            validator: (value) => address1Validator(value),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            inputFormatters: [],
            decoration: InputDecoration(
              hintText: "House number and street name",
              prefixIcon: FormFieldSvgIcon(
                iconPath: "assets/icons/House.svg",
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            controller: widget.address2Controller,
            onSaved: (apartment) {
              // Apartment, suite, unit, etc.
            },
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            inputFormatters: [],
            decoration: InputDecoration(
              hintText: "Apatment, suite, unit, etc. (optional)",
              prefixIcon: FormFieldSvgIcon(
                iconPath: "assets/icons/CityApartment.svg",
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            controller: widget.cityController,
            onSaved: (city) {
              // Town/ City
            },
            validator: (value) => cityValidator(value),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            inputFormatters: [],
            decoration: InputDecoration(
              hintText: "Town/ City",
              prefixIcon: FormFieldSvgIcon(
                iconPath: "assets/icons/Location.svg",
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            controller: widget.postcodeController,
            onSaved: (value) {
              // Postcode/ ZIP
            },
            validator: (value) => postCodeValidator(value),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              hintText: "Postcode/ ZIP",
              prefixIcon: FormFieldSvgIcon(
                iconPath: "assets/icons/PostCard.svg",
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            controller: widget.phoneController,
            validator: (value) => phoneValidator(value),
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              hintText: "Phone",
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: FormFieldSvgIcon(iconPath: "assets/icons/Phone.svg"),
                  ),
                  CountryCodePicker(
                    padding: EdgeInsets.zero,
                    showFlag: false,
                    boxDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        defaultBorderRadius,
                      ),
                      color: whiteColor,
                    ),
                    dialogSize: Size.fromHeight(400),
                    showDropDownButton: true,
                    onChanged: print,
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    alignLeft: false,
                    initialSelection: '+971',
                    searchDecoration: InputDecoration(
                      fillColor: lightGreyColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          defaultBorderRadius,
                        ),
                      ),
                      hintText: 'Search country',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            onPressed: isFormValid
                ? () {
                    if (widget.formKey.currentState?.validate() ?? false) {
                      widget.formKey.currentState?.save();
                      // Handle form submission
                    }
                  }
                : null,
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
