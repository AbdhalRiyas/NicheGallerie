import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_searchable_dropdown/flutter_searchable_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/config/api_contants.dart';
import 'package:shop/src/config/app_config.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/screens/address/views/components/form_field_svg_icon.dart';
import 'package:shop/src/services/api_service.dart';

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
  final TextEditingController emailController;
  final TextEditingController stateController;
  final TextEditingController countryController;
  final VoidCallback validateForm;
  final Map<String, dynamic>? errors;

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
    required this.emailController,
    required this.validateForm,
    this.errors,
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
    widget.firstNameController.addListener(widget.validateForm);
    widget.lastNameController.addListener(widget.validateForm);
    widget.companyNameController.addListener(widget.validateForm);
    widget.address1Controller.addListener(widget.validateForm);
    widget.cityController.addListener(widget.validateForm);
    widget.postcodeController.addListener(widget.validateForm);
    widget.phoneController.addListener(widget.validateForm);
    widget.emailController.addListener(widget.validateForm);
  }

  String? getError(String field) {
    if (widget.errors != null && widget.errors!.containsKey(field)) {
      return widget.errors![field][0];
    }
    return null;
  }

  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? address1Validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? cityValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? postCodeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  final Map<String, List<Map<String, dynamic>>> woocommerceStates = {};

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Form(
        key: widget.formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: widget.firstNameController,
                    onSaved: (fName) {},
                    validator: (value) =>
                        getError('first_name') ?? nameValidator(value),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z]'),
                      ),
                    ],
                    decoration: InputDecoration(
                      hintText: "First name",
                      errorText: getError('first_name'),
                      prefixIcon: FormFieldSvgIcon(
                        iconPath: "assets/icons/Profile.svg",
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: defaultPadding),
                Expanded(
                  child: TextFormField(
                    controller: widget.lastNameController,
                    onSaved: (lName) {},
                    validator: (value) =>
                        getError('last_name') ?? nameValidator(value),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z]'),
                      ),
                    ],
                    decoration: InputDecoration(
                      hintText: "Last name",
                      errorText: getError('last_name'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: defaultPadding),
            TextFormField(
              controller: widget.companyNameController,
              onSaved: (companyName) {},
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: "Company name (optional)",
                errorText: getError('company_name'),
                prefixIcon: FormFieldSvgIcon(
                  iconPath: "assets/icons/Company.svg",
                ),
              ),
            ),
            const SizedBox(height: defaultPadding),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Consumer<AppConfig>(
                builder: (BuildContext context, value, Widget? child) =>
                    SearchableDropdown<String>(
                  items: value.countries.map((country) {
                    return DropdownMenuItem<String>(
                      value: country['code'],
                      child: Text(country['name']!),
                    );
                  }).toList(),
                  value: widget.countryController.text.isEmpty
                      ? null
                      : widget.countryController.text,
                  onChanged: (value) async {
                    setState(() {
                      widget.countryController.text = value!;
                      widget.stateController.text =
                          ''; // Reset state when country changes
                    });

                    // Call the API to fetch states
                    final response = await ApiService().get(
                        "${ApiContants().countries}/${widget.countryController.text}/states");
                    if (response != null) {
                      setState(() {
                        woocommerceStates[widget.countryController.text] =
                            List<Map<String, dynamic>>.from(response);
                      });
                    }
                  },
                  hint: "Select Country",
                  searchHint: "Search for a country",
                  isExpanded: true,
                ),
              ),
            ),
            const SizedBox(height: defaultPadding),
            if (woocommerceStates.containsKey(widget.countryController.text) &&
                woocommerceStates[widget.countryController.text]!.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SearchableDropdown<String>(
                  items: woocommerceStates[widget.countryController.text]!
                      .map((state) {
                    return DropdownMenuItem<String>(
                      value: state['code'],
                      child: Text(state['name']!),
                    );
                  }).toList(),
                  value: widget.stateController.text.isEmpty
                      ? null
                      : widget.stateController.text,
                  onChanged: (value) {
                    setState(() {
                      widget.stateController.text = value!;
                    });
                  },
                  hint: "Select State",
                  searchHint: "Search for a state",
                  isExpanded: true,
                ),
              ),
            const SizedBox(height: defaultPadding),
            TextFormField(
              controller: widget.address1Controller,
              onSaved: (address1) {},
              validator: (value) =>
                  getError('address1') ?? address1Validator(value),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: "House number and street name",
                errorText: getError('address1'),
                prefixIcon: FormFieldSvgIcon(
                  iconPath: "assets/icons/House.svg",
                ),
              ),
            ),
            const SizedBox(height: defaultPadding),
            TextFormField(
              controller: widget.address2Controller,
              onSaved: (apartment) {},
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: "Apartment, suite, unit, etc. (optional)",
                errorText: getError('address2'),
                prefixIcon: FormFieldSvgIcon(
                  iconPath: "assets/icons/CityApartment.svg",
                ),
              ),
            ),
            const SizedBox(height: defaultPadding),
            TextFormField(
              controller: widget.cityController,
              onSaved: (city) {},
              validator: (value) => getError('city') ?? cityValidator(value),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: "Town / City",
                errorText: getError('city'),
                prefixIcon: FormFieldSvgIcon(
                  iconPath: "assets/icons/Location.svg",
                ),
              ),
            ),
            const SizedBox(height: defaultPadding),
            TextFormField(
              controller: widget.postcodeController,
              onSaved: (postcode) {},
              validator: (value) =>
                  getError('postcode') ?? postCodeValidator(value),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: "Postcode / ZIP",
                errorText: getError('postcode'),
                prefixIcon: FormFieldSvgIcon(
                  iconPath: "assets/icons/PostCard.svg",
                ),
              ),
            ),
            const SizedBox(height: defaultPadding),
            TextFormField(
              controller: widget.phoneController,
              onSaved: (phone) {},
              validator: (value) => getError('phone') ?? phoneValidator(value),
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  hintText: "Phone",
                  errorText: getError('phone'),
                  prefixIcon: FormFieldSvgIcon(
                    iconPath: "assets/icons/Phone.svg",
                  )),
            ),
            const SizedBox(height: defaultPadding),
            TextFormField(
              controller: widget.emailController,
              validator: (value) => getError('email') ?? emailValidator(value),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: "Email",
                errorText: getError('email'),
                prefixIcon: FormFieldSvgIcon(
                  iconPath: "assets/icons/Email.svg",
                ),
              ),
            ),
            const SizedBox(height: defaultPadding),
          ],
        ),
      ),
    );
  }
}
