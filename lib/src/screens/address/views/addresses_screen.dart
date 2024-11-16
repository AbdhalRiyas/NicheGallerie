import 'package:flutter/material.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Address'),
      ),
      body: Image.asset(
        "assets/screens/Addresses.png",
        width: double.maxFinite,
        height: double.maxFinite,
      ),
    );
  }
}
