import 'package:flutter/material.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/screens/address/views/components/address_card.dart';

class SelectAddressDialog extends StatefulWidget {
  const SelectAddressDialog({super.key});

  @override
  State<SelectAddressDialog> createState() => _SelectAddressDialogState();
}

class _SelectAddressDialogState extends State<SelectAddressDialog> {
  final List<Map<String, dynamic>> addresses = const [
    {
      'title': 'My home',
      'name': 'Sophi Nowakowska',
      'address': 'Zabiniec 12/222, 31-215 Cracow, Poland',
      'phone': '+79 123 456',
      'countryCode': '789',
      'isDefault': true,
    },
    {
      'title': 'Office',
      'name': 'Rio Nowakowska',
      'address': 'Zabiniec 12/222, 31-215 Cracow, Poland',
      'phone': '+79 123 456',
      'countryCode': '789',
      'isDefault': false,
    },
    {
      'title': "Grandmother's home",
      'name': 'Rio Nowakowska',
      'address': 'Zabiniec 12/222, 31-215 Cracow, Poland',
      'phone': '+79 123 456',
      'countryCode': '789',
      'isDefault': false,
    },
  ];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(defaultPadding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      title: const Text('Select Address'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: addresses.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
              child: AddressCard(
                title: addresses[index]['title'],
                name: addresses[index]['name'],
                address: addresses[index]['address'],
                phone: addresses[index]['phone'],
                countryCode: addresses[index]['countryCode'],
                fromSelect: true,
                isSelected: _selectedIndex == index,
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            );
          },
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
