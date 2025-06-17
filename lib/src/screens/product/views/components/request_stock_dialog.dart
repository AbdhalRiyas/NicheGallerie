import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/repositories/product_repository.dart';

class RequestStockDialog extends StatelessWidget {
  const RequestStockDialog({
    super.key,
    required this.productId,
  });

  final int productId;

  void _showWhatsappDialog(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController countryCodeController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => _WhatsappDialogContent(
        productId: productId,
        phoneController: phoneController,
        countryCodeController: countryCodeController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Out of stock!", style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: defaultPadding / 2),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(300, 50),
              padding: const EdgeInsets.all(0),
            ),
            onPressed: () => _showWhatsappDialog(context),
            child: const Text(
              'Request Stock',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WhatsappDialogContent extends StatefulWidget {
  const _WhatsappDialogContent({
    required this.productId,
    required this.phoneController,
    required this.countryCodeController,
  });

  final int productId;
  final TextEditingController phoneController;
  final TextEditingController countryCodeController;

  @override
  State<_WhatsappDialogContent> createState() => _WhatsappDialogContentState();
}

class _WhatsappDialogContentState extends State<_WhatsappDialogContent> {
  bool _isLoading = false;

  Future<void> _submit() async {
    final String whatsappNumber =
        '${widget.countryCodeController.text}${widget.phoneController.text}';

    if (widget.phoneController.text.isEmpty ||
        widget.countryCodeController.text.isEmpty) {
      toast(
        'Please enter your WhatsApp number with country code.',
      );
      return;
    }
    setState(() => _isLoading = true);
    final result = await ProductRepository().requestStock(
      widget.productId,
      whatsappNumber,
    );
    setState(() => _isLoading = false);

    if (result.isSuccess) {
      log('Stock request sent successfully: ${result.data}');
      toast(
        "${result.message} will be notified via WhatsApp.",
        length: Toast.LENGTH_LONG,
      );
      Navigator.of(context).pop();
    } else {
      log('Error sending stock request: ${result.message}');
      toast(
        "${result.message}, you may have already requested this product.",
        length: Toast.LENGTH_LONG,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(defaultPadding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      title: const Text('Enter your WhatsApp number'),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(defaultBorderRadius),
              color: Colors.grey.withAlpha(50),
            ),
            child: CountryCodePicker(
              padding: EdgeInsets.zero,
              onChanged: (value) {
                widget.countryCodeController.text = value.dialCode ?? '+974';
              },
              showFlagDialog: true,
              showFlagMain: true,
              favorite: ['+974', 'UAE'],
              showFlag: true,
              initialSelection: 'QA',
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
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: widget.phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(17),
              ],
              decoration: InputDecoration(
                hintText: '712345678',
              ),
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Submit'),
        ),
        Center(
          child: TextButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ),
      ],
    );
  }
}
