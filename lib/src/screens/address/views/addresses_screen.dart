import 'package:flutter/material.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/address_model.dart';
import 'package:shop/src/screens/address/views/components/address_button.dart';
import 'package:shop/src/screens/address/views/components/address_card.dart';
import 'package:shop/src/screens/address/views/components/address_dialog.dart';
import 'package:shop/src/screens/address/views/components/addresses_skelton.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  final List<AddressModel> addresses = dummyData;

  void _addNewAddress() {
    showDialog(
      context: context,
      builder: (context) {
        return AddressDialog();
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
              child: AddressButton(
                text: 'Add new address',
                onTap: _addNewAddress,
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
                                      title:
                                          '${address.firstName} ${address.lastName}',
                                      name: address.firstName,
                                      address:
                                          '${address.address1}, ${address.city}, ${address.state}, ${address.country}, ${address.postcode}',
                                      phone: address.phone,
                                      countryCode: address.country,
                                      isDefault: index == 0,
                                      showMenu: true,
                                      onTap: () {}),
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
