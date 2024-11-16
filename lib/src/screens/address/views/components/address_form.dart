import 'package:flutter/material.dart';
import 'package:shop/src/constants.dart';

class AddressForm extends StatefulWidget {
  const AddressForm({super.key});

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      title: const Text('Billing Address'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'First Name',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                        ),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Company Name',
                  ),
                )
                
              ],
            ),
          )
        ],
      ),
      actions: <Widget>[
        Row(
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
