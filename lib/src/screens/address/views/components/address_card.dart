import 'package:flutter/material.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/address_model.dart';
import 'package:shop/src/screens/address/views/components/address_popup_menu.dart';

class AddressCard extends StatelessWidget {
  final AddressModel address;
  final bool? showMenu;
  final VoidCallback? onTap;

  const AddressCard({
    super.key,
    required this.address,
    this.showMenu = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: primaryColor,
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
                      Text(
                        "${address.firstName} ${address.lastName}",
                        style: TextStyle(color: blackColor60),
                      ),
                      Text(
                        address.company,
                        style: TextStyle(color: blackColor60),
                      ),
                      Text(
                        address.address1,
                        style: TextStyle(color: blackColor60),
                      ),
                      Text(
                        address.address2,
                        style: TextStyle(color: blackColor60),
                      ),
                      Text(
                        address.city,
                        style: TextStyle(color: blackColor60),
                      ),
                      Text(
                        "${address.state} ${address.postcode}",
                        style: TextStyle(color: blackColor60),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            address.phone,
                            style: TextStyle(color: blackColor60),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            address.country,
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
        ],
      ),
    );
    return cardContent;
  }
}
