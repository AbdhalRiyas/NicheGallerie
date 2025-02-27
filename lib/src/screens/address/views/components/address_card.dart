import 'package:flutter/material.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/address_model.dart';

class AddressCard extends StatelessWidget {
  final AddressModel address;
  final VoidCallback? onTap;
  final bool onAddressScreen;

  const AddressCard({
    super.key,
    required this.address,
    this.onTap,
    this.onAddressScreen = true,
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
                if (onAddressScreen) ...[
                  Text(
                      'The following addresses will be used on the checkout page by default.'),
                  SizedBox(height: 8),
                ],
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
                Text("${address.city}, ${address.state} ${address.postcode}",
                    style: TextStyle(
                      color: blackColor90,
                      fontStyle: FontStyle.italic,
                    )),
                Text(
                  address.country,
                  style: TextStyle(
                    color: blackColor90,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                if (onAddressScreen) ...[
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      'Edit Billing Address',
                      style: TextStyle(color: sandDuneColor),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
    return cardContent;
  }
}
