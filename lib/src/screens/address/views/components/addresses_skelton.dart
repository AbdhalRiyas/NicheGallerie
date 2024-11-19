import 'package:flutter/material.dart';
import 'package:shop/src/screens/address/views/components/address_card_skelton.dart';

class AddressesSkelton extends StatelessWidget {
  const AddressesSkelton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 3,
        itemBuilder: (context, index) => AddressCardSkelton(),
      ),
    );
  }
}
