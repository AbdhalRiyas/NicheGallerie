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
    Widget cardContent = Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'The following addresses will be used on the checkout page by default.'),
                SizedBox(height: 8),
                Text("${address.firstName} ${address.lastName}",
                    style: TextStyle(
                      color: blackColor90,
                      fontStyle: FontStyle.italic,
                    )),
                if (address.company != '')
                  Text(address.company,
                      style: TextStyle(
                        color: blackColor90,
                        fontStyle: FontStyle.italic,
                      )),
                Text(address.address1,
                    style: TextStyle(
                      color: blackColor90,
                      fontStyle: FontStyle.italic,
                    )),
                if (address.address2 != '')
                  Text(address.address2,
                      style: TextStyle(
                        color: blackColor90,
                        fontStyle: FontStyle.italic,
                      )),
                Text(address.city,
                    style: TextStyle(
                      color: blackColor90,
                      fontStyle: FontStyle.italic,
                    )),
                Text("${address.state} ${address.postcode}",
                    style: TextStyle(
                      color: blackColor90,
                      fontStyle: FontStyle.italic,
                    )),
                Text(address.phone,
                    style: TextStyle(
                      color: blackColor90,
                      fontStyle: FontStyle.italic,
                    )),
                const SizedBox(width: 8),
                Text(
                  address.country,
                  style: TextStyle(
                    color: blackColor90,
                    fontStyle: FontStyle.italic,
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
