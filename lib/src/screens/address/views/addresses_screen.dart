import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/screens/address/views/components/address_card.dart';
import 'package:shop/src/screens/address/views/components/address_form.dart';
import 'package:shop/src/screens/address/views/components/addresses_skelton.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
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

  void _addNewAddress() {
    showDialog(
      context: context,
      builder: (context) {
        return AddressForm();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Address'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(
                defaultPadding,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  border: DashedBorder.fromBorderSide(
                    dashLength: 5,
                    side: BorderSide(color: whileColor80, width: 2),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(defaultBorderRadius),
                  ),
                ),
                child: Center(
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/Location.svg",
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(width: 8),
                        const Text('Add new address'),
                      ],
                    ),
                    onTap: _addNewAddress,
                  ),
                ),
              ),
            ),
            Expanded(
              child: addresses.isEmpty
                  ? Center(
                      child: Text('No addresses'),
                    )
                  : FutureBuilder(
                      future: Future.delayed(Duration(milliseconds: 500)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ListView.builder(
                            padding: const EdgeInsets.all(defaultPadding),
                            itemCount: addresses.length,
                            itemBuilder: (context, index) {
                              final address = addresses[index];
                              return Column(
                                children: [
                                  AddressCard(
                                    title: address['title'],
                                    name: address['name'],
                                    address: address['address'],
                                    phone: address['phone'],
                                    countryCode: address['countryCode'],
                                    isDefault: address['isDefault'],
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              );
                            },
                          );
                        } else {
                          return AddressesSkelton();
                        }
                      }),
            ),
          ],
        ),
      ),
    );
  }
}
