import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop/src/constants.dart';

class CountryStatePicker extends StatefulWidget {
  const CountryStatePicker({super.key});

  @override
  State<CountryStatePicker> createState() => _CountryStatePickerState();
}

class _CountryStatePickerState extends State<CountryStatePicker> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(defaultBorderRadius),
              color: lightGreyColor,
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: defaultPadding * 0.75,
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/Country.svg",
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
                SizedBox(width: 8),
                Expanded(
                  child: CSCPicker(
                    ///Enable disable state dropdown [OPTIONAL PARAMETER]
                    showStates: false,

                    /// Enable disable city drop down [OPTIONAL PARAMETER]
                    showCities: false,

                    ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                    flagState: CountryFlag.DISABLE,

                    ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]
                    dropdownDecoration: BoxDecoration(
                      color: lightGreyColor,
                    ),

                    ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                    disabledDropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.grey.shade300,
                      border: Border.all(color: Colors.grey.shade300, width: 1),
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
                    onCountryChanged: (value) {
                      setState(() {
                        ///store value in country variable
                      });
                    },

                    ///triggers once state selected in dropdown
                    onStateChanged: (value) {
                      setState(() {
                        ///store value in state variable
                      });
                    },

                    ///triggers once city selected in dropdown
                    onCityChanged: (value) {
                      setState(() {
                        ///store value in city variable
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
