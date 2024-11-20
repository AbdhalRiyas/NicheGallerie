import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop/src/constants.dart';

class AddressPopupMenu extends StatelessWidget {
  const AddressPopupMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: whiteColor,
      icon: SvgPicture.asset(
        "assets/icons/DotsV.svg",
        height: 24,
        width: 24,
      ),
      onSelected: (String result) {
        if (result == 'edit') {
          // Handle edit address
        } else if (result == 'delete') {
          // Handle delete address
        } else if (result == 'default') {
          // Handle set as default address
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'default',
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: defaultPadding * 0.5,
                  horizontal: defaultPadding / 2,
                ),
                child: SvgPicture.asset(
                  'assets/icons/Star.svg',
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withOpacity(0.3),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Text('Set as Default Address'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: defaultPadding * 0.5,
                  horizontal: defaultPadding / 2,
                ),
                child: SvgPicture.asset(
                  'assets/icons/Edit Square.svg',
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withOpacity(0.3),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Text('Edit Address'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: defaultPadding * 0.5,
                  horizontal: defaultPadding / 2,
                ),
                child: SvgPicture.asset(
                  'assets/icons/Delete.svg',
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withOpacity(0.3),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Text('Delete Address'),
            ],
          ),
        ),
      ],
    );
  }
}
