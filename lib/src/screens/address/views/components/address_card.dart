import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:shop/src/constants.dart';
import 'package:shop/src/screens/address/views/components/form_field_svg_icon.dart';

class AddressCard extends StatelessWidget {
  final String title;
  final String name;
  final String address;
  final String phone;
  final String countryCode;
  final bool isDefault;

  const AddressCard({
    super.key,
    required this.title,
    required this.name,
    required this.address,
    required this.phone,
    required this.countryCode,
    this.isDefault = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: isDefault ? primaryColor : greyColor,
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
            bottom: 0,
            right: 0,
            child: PopupMenuButton<String>(
              color: whiteColor,
              icon: SvgPicture.asset(
                "assets/icons/DotsV.svg",
                height: 24,
                width: 24,
              ),
              onSelected: (String result) {
                if (result == 'edit') {
                  // Handle edit address
                } else if (result == 'delete') {
                  // Handle delete address
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'default',
                  child: Row(
                    children: [
                      FormFieldSvgIcon(iconPath: 'assets/icons/Edit-Bold.svg'),
                      Text('Set as Default Address'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      FormFieldSvgIcon(iconPath: 'assets/icons/Edit-Bold.svg'),
                      Text('Edit Address'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      FormFieldSvgIcon(iconPath: 'assets/icons/Delete.svg'),
                      Text('Delete Address'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isDefault)
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
  }
}
