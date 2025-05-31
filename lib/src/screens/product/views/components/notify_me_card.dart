import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop/src/constants.dart';

class NotifyMeCard extends StatelessWidget {
  const NotifyMeCard({
    super.key,
  });

  void _showWhatsappDialog(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController countryCodeController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.all(defaultPadding),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
        ),
        title: const Text('Enter your WhatsApp number'),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 110, // Adjust width as needed
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultBorderRadius),
                color: Colors.grey.withAlpha(50),
              ),
              child: CountryCodePicker(
                padding: EdgeInsets.zero,
                onChanged: (value) {
                  countryCodeController.text = value.dialCode ?? '+974';
                },
                initialSelection: 'UAE',
                favorite: ['+974', 'UAE'],
                showFlag: true,
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
                alignLeft: true,
                searchDecoration: InputDecoration(
                  hintText: 'Search country',
                ),
                emptySearchBuilder: (context) => Center(
                  child: Text(
                    'No country found',
                  ),
                ),
              ),
            ),
            const SizedBox(
                width: 8), // Add spacing between picker and text field
            Expanded(
              child: TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(17),
                ],
                decoration: InputDecoration(
                  hintText: '0712345678',
                ),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final String phoneNumber = phoneController.text.trim();
              final String countryCode = countryCodeController.text.trim();
              log('Phone Number: $countryCode$phoneNumber');
            },
            child: const Text('Submit'),
          ),
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text("Out of stock!", style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(width: defaultPadding),
          Flexible(
            child: ElevatedButton(
              onPressed: () => _showWhatsappDialog(context),
              child: const Text('Request Stock'),
            ),
          ),
        ],
      ),
    );
  }
}
