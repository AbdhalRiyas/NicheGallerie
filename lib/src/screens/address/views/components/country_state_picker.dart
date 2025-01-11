import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/screens/address/views/components/form_field_svg_icon.dart';

class CountryStatePicker extends StatelessWidget {
  const CountryStatePicker(
      {super.key,
      required this.countryController,
      required this.stateController});

  final TextEditingController countryController, stateController;
  @override
  Widget build(BuildContext context) {
    return FormField(
      validator: (value) {
        if (countryController.text.isEmpty) {
          return 'Please select a country.';
        }
        if (stateController.text.isEmpty) {
          return 'Please select a state.';
        }
        return null; // No error
      },
      builder: (FormFieldState<dynamic> field) => Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(defaultBorderRadius),
            color: lightGreyColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                FormFieldSvgIcon(iconPath: 'assets/icons/Country.svg'),
                SizedBox(width: defaultPadding),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: CSCPicker(
                      ///Enable disable state dropdown [OPTIONAL PARAMETER]
                      showStates: true,

                      /// Enable disable city drop down [OPTIONAL PARAMETER]
                      showCities: false,

                      ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                      flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,

                      ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(defaultBorderRadius)),
                        // border: Border.all(color: greyColor, width: 1),
                        color: lightGreyColor,
                      ),

                      ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                      disabledDropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(defaultBorderRadius)),
                        color: lightGreyColor,
                        // border: Border.all(color: greyColor, width: 1),
                      ),

                      ///placeholders for dropdown search field
                      countrySearchPlaceholder: "Country",
                      stateSearchPlaceholder: "State",
                      citySearchPlaceholder: "City",

                      ///labels for dropdown
                      countryDropdownLabel: "Country/ Region",
                      stateDropdownLabel: "State",
                      cityDropdownLabel: "City",

                      ///selected item style [OPTIONAL PARAMETER]
                      selectedItemStyle: TextStyle(
                        color: blackColor,
                        fontSize: 14,
                      ),

                      ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                      dropdownHeadingStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),

                      ///DropdownDialog Item style [OPTIONAL PARAMETER]
                      dropdownItemStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),

                      ///Dialog box radius [OPTIONAL PARAMETER]
                      dropdownDialogRadius: defaultBorderRadius,

                      ///Search bar radius [OPTIONAL PARAMETER]
                      searchBarRadius: defaultBorderRadius,

                      ///triggers once country selected in dropdown
                      onCountryChanged: (value) =>
                          countryController.text = value ?? '',

                      ///triggers once state selected in dropdown
                      onStateChanged: (value) =>
                          stateController.text = value ?? '',

                      ///triggers once city selected in dropdown
                      onCityChanged: (value) {},
                    ),
                  ),
                ),
              ],
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  field.errorText ?? '',
                  style: TextStyle(color: Colors.red[700], fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
