import 'package:flutter/material.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/address_model.dart';
import 'package:shop/src/screens/address/views/components/address_card.dart';
import 'package:shop/src/screens/address/views/components/address_dialog.dart';

class SelectAddressDialog extends StatefulWidget {
  const SelectAddressDialog({super.key, required this.onAddressSelected});

  final Function(AddressModel) onAddressSelected;

  @override
  State<SelectAddressDialog> createState() => _SelectAddressDialogState();
}

class _SelectAddressDialogState extends State<SelectAddressDialog> {
  final List<AddressModel> addresses = dummyData;
  int _selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(defaultPadding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      title: Center(
        child: Text(
          'Select Address',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: blackColor,
          ),
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (context) {
                    return AddressDialog();
                  },
                );
              },
              child: const Text('Add New Address'),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: defaultPadding / 2),
                  child: AddressCard(
                    title:
                        '${addresses[index].firstName} ${addresses[index].lastName}',
                    name: addresses[index].lastName,
                    address: addresses[index].address1,
                    phone: addresses[index].phone,
                    countryCode: addresses[index].country,
                    fromSelect: true,
                    isSelected: _selectedIndex == index,
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                      widget.onAddressSelected(addresses[index]);
                      Navigator.of(context).pop();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ),
      ],
    );
  }
}
