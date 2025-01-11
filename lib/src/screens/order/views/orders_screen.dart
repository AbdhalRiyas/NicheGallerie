import 'package:flutter/material.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/repositories/order_repository.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderRepository orderRepository = OrderRepository();

    orderRepository.fetchOrders();

    final Map<String, dynamic> orderStatus = {
      'pending': {
        'title': 'Awaiting Payment',
        'color': Colors.orangeAccent, // A warm color for waiting
      },
      'processing': {
        'title': 'Ready to Ship',
        'color': Colors.blue, // Indicates action is in progress
      },
      'on-hold': {
        'title': 'On Hold',
        'color': Colors.grey, // Neutral color for paused state
      },
      'completed': {
        'title': 'Shipped',
        'color': Colors.green, // Green for success and completion
      },
      'cancelled': {
        'title': 'Cancelled',
        'color': Colors.redAccent, // Red for cancellation
      },
      'refunded': {
        'title': 'Refunded',
        'color': Colors.purple, // Purple for financial adjustments
      },
      'failed': {
        'title': 'Payment Failed',
        'color': Colors.red, // Bold red for critical failure
      },
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'.toUpperCase()),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: defaultPadding / 3),
        child: ListView.builder(
          itemBuilder: (context, index) => Container(
            padding: EdgeInsets.all(defaultPadding),
            margin: EdgeInsets.symmetric(vertical: defaultPadding / 4),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(13, 0, 0, 0),
                  blurRadius: 10,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "#46994",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: sandDuneColor,
                            ),
                          ),
                          Text(
                            orderStatus['processing']['title'],
                            style: TextStyle(
                              color: orderStatus['processing']['color'],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: defaultPadding / 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "AED3,398 for 3 items",
                            style: TextStyle(
                              color: blackColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "January 7, 2025",
                            style: TextStyle(
                              color: blackColor,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: defaultPadding),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          "Cancel",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    SizedBox(width: 2),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          "Order Again",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    SizedBox(width: 2),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          "Pay",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
