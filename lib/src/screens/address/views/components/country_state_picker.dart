import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/screens/address/views/components/form_field_svg_icon.dart';

class CountryStatePicker extends StatelessWidget {
  const CountryStatePicker({
    super.key,
    required this.countryController,
    required this.stateController,
  });

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
          color: lightGreyColor,
        ),
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
                      showStates: true,
                      showCities: false,
                      flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(defaultBorderRadius),
                        ),
                        color: lightGreyColor,
                      ),
                      disabledDropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(defaultBorderRadius),
                        ),
                        color: lightGreyColor,
                      ),
                      countrySearchPlaceholder: "Country",
                      stateSearchPlaceholder: "State",
                      citySearchPlaceholder: "City",
                      countryDropdownLabel: "Country/ Region",
                      stateDropdownLabel: "State",
                      cityDropdownLabel: "City",
                      selectedItemStyle: TextStyle(
                        color: blackColor,
                        fontSize: 14,
                      ),
                      dropdownHeadingStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      dropdownItemStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      dropdownDialogRadius: defaultBorderRadius,
                      searchBarRadius: defaultBorderRadius,
                      onCountryChanged: (value) =>
                          countryController.text = value ?? '',
                      onStateChanged: (value) =>
                          stateController.text = value ?? '',
                      onCityChanged: (value) {},
                      currentState: stateController.text,
                      defaultCountry: countryController.text.isNotEmpty
                          ? CscCountry.values.firstWhere(
                              (e) =>
                                  e.name.replaceAll('_', ' ') ==
                                  countryController.text,
                              orElse: () =>
                                  CscCountry.United_States, // Default fallback
                            )
                          : null,
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
