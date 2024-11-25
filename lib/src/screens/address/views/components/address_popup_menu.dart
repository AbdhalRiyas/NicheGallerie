import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/screens/address/views/components/popup_menu_item_svg.dart';

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
              PopupMenuItemSvgIcon(
                iconPath: 'assets/icons/Star.svg',
              ),
              Text('Set as Default Address'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              PopupMenuItemSvgIcon(
                iconPath: 'assets/icons/Edit Square.svg',
              ),
              Text('Edit Address'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              PopupMenuItemSvgIcon(
                iconPath: 'assets/icons/Delete.svg',
              ),
              Text('Delete Address'),
            ],
          ),
        ),
      ],
    );
  }
}
