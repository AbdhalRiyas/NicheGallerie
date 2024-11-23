import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/screens/search/views/components/search_form.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> orderStatuses = [
      {
        'svgIcon': 'assets/icons/Payonline.svg',
        'title': 'Awaiting Payment',
        'count': 0,
        'color': Colors.orange,
      },
      {
        'svgIcon': 'assets/icons/Product.svg',
        'title': 'Processing',
        'count': 1,
        'color': Colors.blue,
      },
      {
        'svgIcon': 'assets/icons/Delivery.svg',
        'title': 'Delivered',
        'count': 5,
        'color': Colors.blue,
      },
      {
        'svgIcon': 'assets/icons/Return.svg',
        'title': 'Returned',
        'count': 3,
        'color': Colors.blue,
      },
      {
        'svgIcon': 'assets/icons/Close-Circle.svg',
        'title': 'Canceled',
        'count': 2,
        'color': Colors.red,
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchForm(
              hintText: 'Search an Order',
            ),
            SizedBox(height: defaultPadding),
            Text(
              'Orders History',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: defaultPadding),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: orderStatuses.length,
                separatorBuilder: (context, index) => const Divider(
                  color: blackColor40,
                ),
                itemBuilder: (context, index) {
                  final status = orderStatuses[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Padding(
                        padding: const EdgeInsets.all(defaultPadding / 2),
                        child: SvgPicture.asset(
                          status['svgIcon'],
                          height: 30,
                          width: 30,
                        )),
                    title: Text(
                      status['title'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: status['color'] as Color,
                            borderRadius:
                                BorderRadius.circular(defaultBorderRadius),
                          ),
                          child: Text(
                            (status['count'] as int).toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: defaultPadding / 2),
                        const Icon(Icons.chevron_right, color: Colors.black54),
                      ],
                    ),
                    onTap: () {
                      // Handle navigation to specific order status list
                    },
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
