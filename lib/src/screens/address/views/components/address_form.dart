import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/screens/address/views/components/country_state_picker.dart';

class AddressForm extends StatefulWidget {
  const AddressForm({super.key});

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
        title: const Text('Add Address'),
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
                              onSaved: (fName) {
                                // First Name
                              },
                              // validator: ,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              inputFormatters: [],
                              decoration: InputDecoration(
                                hintText: "First name",
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: defaultPadding * 0.75,
                                  ),
                                  child: SvgPicture.asset(
                                    "assets/icons/Profile.svg",
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
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: defaultPadding),
                          Expanded(
                            child: TextFormField(
                              onSaved: (lName) {
                                // Last Name
                              },
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [],
                              decoration: InputDecoration(
                                hintText: "Last name",
                                // prefixIcon: Padding(
                                //   padding: const EdgeInsets.symmetric(
                                //     vertical: defaultPadding * 0.75,
                                //   ),
                                //   child: SvgPicture.asset(
                                //     "assets/icons/Profile.svg",
                                //     height: 24,
                                //     width: 24,
                                //     colorFilter: ColorFilter.mode(
                                //       Theme.of(context)
                                //           .textTheme
                                //           .bodyLarge!
                                //           .color!
                                //           .withOpacity(0.3),
                                //       BlendMode.srcIn,
                                //     ),
                                //   ),
                                // ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: defaultPadding),
                      TextFormField(
                        onSaved: (companyName) {
                          // Company Name
                        },
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [],
                        decoration: InputDecoration(
                          hintText: "Company name (optional)",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding * 0.75,
                            ),
                            child: SvgPicture.asset(
                              "assets/icons/Company.svg",
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
                          ),
                        ),
                      ),
                      const SizedBox(height: defaultPadding),
                      CountryStatePicker(),
                      TextFormField(
                        onSaved: (companyName) {
                          // Company Name
                        },
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [],
                        decoration: InputDecoration(
                          hintText: "House number and street name",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding * 0.75,
                            ),
                            child: SvgPicture.asset(
                              "assets/icons/House.svg",
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
                          ),
                        ),
                      ),
                      const SizedBox(height: defaultPadding),
                      TextFormField(
                        onSaved: (companyName) {
                          // Company Name
                        },
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [],
                        decoration: InputDecoration(
                          hintText: "Apatment, suite, unit, etc. (optional)",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding * 0.75,
                            ),
                            child: SvgPicture.asset(
                              "assets/icons/CityApartment.svg",
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
                          ),
                        ),
                      ),
                      const SizedBox(height: defaultPadding),
                      TextFormField(
                        onSaved: (companyName) {
                          // Company Name
                        },
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [],
                        decoration: InputDecoration(
                          hintText: "Town/ City",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding * 0.75,
                            ),
                            child: SvgPicture.asset(
                              "assets/icons/Location.svg",
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
                          ),
                        ),
                      ),
                      const SizedBox(height: defaultPadding),
                      TextFormField(
                        onSaved: (companyName) {
                          // Company Name
                        },
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [],
                        decoration: InputDecoration(
                          hintText: "Postcode/ ZIP",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding * 0.75,
                            ),
                            child: SvgPicture.asset(
                              "assets/icons/PostCard.svg",
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
                          ),
                        ),
                      ),
                      const SizedBox(height: defaultPadding),
                      Row(
                        children: [
                          CountryCodePicker(
                            boxDecoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(defaultBorderRadius),
                              color: lightGreyColor,
                            ),
                            dialogSize: Size.fromHeight(400),
                            onChanged: print,
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            alignLeft: false,
                          ),
                          Expanded(
                            child: TextFormField(
                              onSaved: (companyName) {
                                // Company Name
                              },
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [],
                              decoration: InputDecoration(
                                hintText: "Phone",
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: defaultPadding * 0.75,
                                  ),
                                  child: SvgPicture.asset(
                                    "assets/icons/Phone.svg",
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
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: defaultPadding),
                      TextFormField(
                        onSaved: (companyName) {
                          // Company Name
                        },
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        inputFormatters: [],
                        decoration: InputDecoration(
                          hintText: "Email address",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding * 0.75,
                            ),
                            child: SvgPicture.asset(
                              "assets/icons/Email.svg",
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
                          ),
                        ),
                      ),
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
