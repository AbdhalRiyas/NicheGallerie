import 'package:flutter/material.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/screens/address/views/components/address_popup_menu.dart';

class AddressCard extends StatelessWidget {
  final String title;
  final String name;
  final String address;
  final String phone;
  final String countryCode;
  final bool? isDefault;
  final bool fromSelect;
  final bool? isSelected;
  final bool? showMenu;
  final VoidCallback? onTap;

  const AddressCard({
    super.key,
    required this.title,
    required this.name,
    required this.address,
    required this.phone,
    required this.countryCode,
    this.isDefault = false,
    this.fromSelect = false,
    this.isSelected = false,
    this.showMenu = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: isDefault! || isSelected! ? primaryColor : greyColor,
        ),
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: blackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        name,
                        style: TextStyle(color: blackColor60),
                      ),
                      Text(
                        address,
                        style: TextStyle(color: blackColor60),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            phone,
                            style: TextStyle(color: blackColor60),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            countryCode,
                            style: TextStyle(color: blackColor60),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: fromSelect ? 0 : null,
            bottom: 0,
            right: fromSelect ? 5 : 0,
            child: fromSelect
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      isSelected!
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: isSelected! ? primaryColor : blackColor60,
                    ),
                  )
                : showMenu!
                    ? AddressPopupMenu()
                    : const SizedBox.shrink(),
          ),
          if (isDefault!)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding / 2,
                  vertical: defaultPadding / 3,
                ),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(defaultBorderRadius),
                    bottomLeft: Radius.circular(defaultBorderRadius),
                  ),
                ),
                child: const Text(
                  'Default',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    if (fromSelect) {
      cardContent = InkWell(
        onTap: () {
          onTap!();
        },
        child: cardContent,
      );
    }
    return cardContent;
  }
}
