import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: defaultPadding),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
        ),
        title: const Text('Billing Address'),
        content: SizedBox(
          width: double.maxFinite, // Set full width
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        onSaved: (emal) {
                          // Email
                        },
                        validator: emaildValidator.call,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        inputFormatters: [],
                        decoration: InputDecoration(
                          hintText: "Email address",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: defaultPadding * 0.75),
                            child: SvgPicture.asset(
                              "assets/icons/Message.svg",
                              height: 24,
                              width: 24,
                              colorFilter: ColorFilter.mode(
                                  Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color!
                                      .withOpacity(0.3),
                                  BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'First Name',
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
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Company Name',
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Company Name',
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Company Name',
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Company Name',
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Company Name',
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
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
      ),
    );
  }
}
