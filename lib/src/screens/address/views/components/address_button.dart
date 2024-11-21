import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:shop/src/constants.dart';

class AddressButton extends StatelessWidget {
  const AddressButton({super.key, required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Text(text),
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
