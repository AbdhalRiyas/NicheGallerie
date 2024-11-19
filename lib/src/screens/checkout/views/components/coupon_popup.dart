import 'package:flutter/material.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/screens/address/views/components/form_field_svg_icon.dart';

class CouponPopup extends StatelessWidget {
  const CouponPopup({
    super.key,
    required TextEditingController couponController,
  }) : _couponController = couponController;

  final TextEditingController _couponController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(defaultPadding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      title: Text('Coupon Code'),
      content: TextField(
        controller: _couponController,
        decoration: InputDecoration(
          hintText: 'Enter your coupon code',
          prefixIcon: FormFieldSvgIcon(
            iconPath: 'assets/icons/Tag.svg',
          ),
        ),
      ),
      actions: [
        Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Apply'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        ),
      ],
    );
  }
}
