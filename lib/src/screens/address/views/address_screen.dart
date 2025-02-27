import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shop/src/components/empty_error_state_widget.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/address_model.dart';
import 'package:shop/src/repositories/user_repository.dart';
import 'package:shop/src/screens/address/views/components/address_button.dart';
import 'package:shop/src/screens/address/views/components/address_card.dart';
import 'package:shop/src/screens/address/views/components/address_dialog.dart';
import 'package:shop/src/screens/address/views/components/addresses_skelton.dart';
import 'package:shop/src/utils/result.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final UserRepository _userRepository = UserRepository();

  late Future<Result> _address;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    _address = _userRepository.getBillingAddress();
  }

  void _addEditAddress(AddressModel address) async {
    await showDialog<Result>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AddressDialog(addressModel: address),
    );

    setState(() {
      _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Billing Address'),
      ),
      body: FutureBuilder<Result>(
        future: _address,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AddressesSkelton();
          } else if (snapshot.hasError) {
            return NoDataWidget(
              title: snapshot.error.toString(),
              imageWidget: const ErrorStateWidget(),
              retryText: 'Reload',
              onRetry: () {
                _fetchData();
                setState(() {});
              },
            );
          } else if (snapshot.hasData) {
            final result = snapshot.data!;
            if (result.isSuccess) {
              final data = result.data;

              return (data.isEmpty || data['first_name'] == '')
                  ? Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: AddressButton(
                        text: 'Add new address',
                        onTap: () =>
                            _addEditAddress(AddressModel.fromJson(data)),
                      ),
                    )
                  : AddressCard(
                      address: AddressModel.fromJson(data),
                      onTap: () => _addEditAddress(AddressModel.fromJson(data)),
                    );
            } else {
              return NoDataWidget(
                title: result.message,
                imageWidget: const ErrorStateWidget(),
                retryText: 'Reload',
                onRetry: () {
                  _fetchData();
                  setState(() {});
                },
              );
            }
          } else {
            return const AddressesSkelton();
          }
        },
      ),
    );
  }
}
