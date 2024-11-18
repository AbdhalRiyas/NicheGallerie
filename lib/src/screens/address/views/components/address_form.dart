import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/screens/address/views/components/country_state_picker.dart';
import 'package:shop/src/screens/address/views/components/form_field_svg_icon.dart';

class AddressForm extends StatefulWidget {
  const AddressForm({super.key});

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
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

  nameValidator(String? value) {
    if (value == null ||
        value.isEmpty ||
        value.length < 3 ||
        value.length > 20) {
      return 'Enter valid name';
    }
    return null;
  }

  address1Validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address is required';
    }
    return null;
  }

  cityValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'City is required';
    }
    return null;
  }

  postCodeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Postcode is required';
    }
    return null;
  }

  phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    return null;
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
        title: const Text('Add new address'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _firstNameController,
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
                              controller: _lastNameController,
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
                        controller: _companyNameController,
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
                        stateController: _stateController,
                        countryController: _countryController,
                      ),
                      const SizedBox(height: defaultPadding),
                      TextFormField(
                        controller: _address1Controller,
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
                        controller: _address2Controller,
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
                        controller: _cityController,
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
                        controller: _postcodeController,
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
                        controller: _phoneController,
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: defaultPadding),
                                child: FormFieldSvgIcon(
                                    iconPath: "assets/icons/Phone.svg"),
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
                      // TextFormField(
                      //   onSaved: (companyName) {
                      //     // Company Name
                      //   },
                      //   keyboardType: TextInputType.emailAddress,
                      //   textInputAction: TextInputAction.done,
                      //   inputFormatters: [],
                      //   decoration: InputDecoration(
                      //     hintText: "Email address",
                      //     prefixIcon: Padding(
                      //       padding: const EdgeInsets.symmetric(
                      //         vertical: defaultPadding * 0.75,
                      //       ),
                      //       child: SvgPicture.asset(
                      //         "assets/icons/Email.svg",
                      //         height: 24,
                      //         width: 24,
                      //         colorFilter: ColorFilter.mode(
                      //           Theme.of(context)
                      //               .textTheme
                      //               .bodyLarge!
                      //               .color!
                      //               .withOpacity(0.3),
                      //           BlendMode.srcIn,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        actions: <Widget>[
          Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    print('Saved');
                    print(_firstNameController.text);
                    print(_lastNameController.text);
                    print(_companyNameController.text);
                    print(_address1Controller.text);
                    print(_address2Controller.text);
                    print(_cityController.text);
                    print(_postcodeController.text);
                    print(_phoneController.text);
                  }
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
