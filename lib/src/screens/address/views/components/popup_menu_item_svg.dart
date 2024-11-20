import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop/src/constants.dart';

class PopupMenuItemSvgIcon extends StatelessWidget {
  const PopupMenuItemSvgIcon({
    super.key,
    required this.iconPath,
  });

  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: defaultPadding * 0.5,
        horizontal: defaultPadding / 2,
      ),
      child: SvgPicture.asset(
        iconPath,
        height: 24,
        width: 24,
        colorFilter: ColorFilter.mode(
          Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.3),
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
