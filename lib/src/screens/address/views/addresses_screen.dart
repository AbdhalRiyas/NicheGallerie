import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/screens/address/views/components/address_card.dart';
import 'package:shop/src/screens/address/views/components/address_form.dart';
import 'package:shop/src/screens/search/views/components/search_form.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  final List<Map<String, dynamic>> addresses = const [
    {
      'title': 'My home',
      'name': 'Sophi Nowakowska',
      'address': 'Zabiniec 12/222, 31-215 Cracow, Poland',
      'phone': '+79 123 456',
      'countryCode': '789',
      'isDefault': true,
      'iconColor': Colors.purple,
    },
    {
      'title': 'Office',
      'name': 'Rio Nowakowska',
      'address': 'Zabiniec 12/222, 31-215 Cracow, Poland',
      'phone': '+79 123 456',
      'countryCode': '789',
      'isDefault': false,
      'iconColor': Colors.green,
    },
    {
      'title': "Grandmother's home",
      'name': 'Rio Nowakowska',
      'address': 'Zabiniec 12/222, 31-215 Cracow, Poland',
      'phone': '+79 123 456',
      'countryCode': '789',
      'isDefault': false,
      'iconColor': Colors.green,
    },
  ];

  void _addNewAddress() {
    showDialog(
      context: context,
      builder: (context) {
        return AddressForm();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Address'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: defaultPadding,
                right: defaultPadding,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: greyColor),
                  borderRadius: BorderRadius.circular(defaultBorderRadius),
                ),
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
                      const Text('Add new address'),
                    ],
                  ),
                  onTap: _addNewAddress,
                ),
              ),
            ),
            Expanded(
              child: addresses.isEmpty
                  ? Center(
                      child: Text('No addresses'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(defaultPadding),
                      itemCount: addresses.length,
                      itemBuilder: (context, index) {
                        final address = addresses[index];
                        return Column(
                          children: [
                            AddressCard(
                              title: address['title'],
                              name: address['name'],
                              address: address['address'],
                              phone: address['phone'],
                              countryCode: address['countryCode'],
                              isDefault: address['isDefault'],
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width, startY),
        Offset(size.width, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    startX = size.width;
    while (startX > 0) {
      canvas.drawLine(
        Offset(startX, size.height),
        Offset(startX - dashWidth, size.height),
        paint,
      );
      startX -= dashWidth + dashSpace;
    }

    startY = size.height;
    while (startY > 0) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY - dashWidth),
        paint,
      );
      startY -= dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
