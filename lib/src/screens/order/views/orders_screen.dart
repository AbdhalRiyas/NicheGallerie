import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shop/src/components/empty_error_state_widget.dart';
import 'package:shop/src/components/skeleton/others/categories_skelton.dart';
import 'package:shop/src/components/skeleton/product/products_skelton.dart';
import 'package:shop/src/components/skeleton/skeleton.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/order.dart';
import 'package:shop/src/repositories/order_repository.dart';
import 'package:shop/src/route/screen_export.dart';
import 'package:shop/src/utils/result.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderRepository orderRepository = OrderRepository();

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
        child: SnapHelperWidget<Result>(
          future: orderRepository.fetchOrders(),
          onSuccess: (result) {
            if (result.isSuccess && result.data.isNotEmpty) {
              List<Order> orders = result.data;

              // Render data if the result indicates success
              return ListView.builder(
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
                        onTap: () {
                          context.goNamed(viewOrderScreen, pathParameters: {
                            'id': orders[index].id.toString(),
                          });
                        },
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "#${orders[index].id}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: sandDuneColor,
                                  ),
                                ),
                                Text(
                                  orderStatus[orders[index].status]['title'],
                                  style: TextStyle(
                                    color: orderStatus[orders[index].status]
                                        ['color'],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: defaultPadding / 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${orders[index].currency} ${orders[index].total} for ${orderRepository.totalItemsInOrder(orders[index].items)} ${orderRepository.totalItemsInOrder(orders[index].items) > 1 ? 'items' : 'item'}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  DateFormat('MMMM d, yyyy').format(
                                      DateTime.parse(
                                          orders[index].dateCreated)),
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      // SizedBox(height: defaultPadding),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: ElevatedButton(
                      //         onPressed: () {},
                      //         child: Text(
                      //           "Cancel",
                      //           style: TextStyle(fontSize: 12),
                      //         ),
                      //       ),
                      //     ),
                      //     SizedBox(width: 2),
                      //     Expanded(
                      //       child: ElevatedButton(
                      //         onPressed: () {},
                      //         child: Text(
                      //           "Order Again",
                      //           style: TextStyle(fontSize: 12),
                      //         ),
                      //       ),
                      //     ),
                      //     if (orders[index].status == 'pending')
                      //       SizedBox(width: 2),
                      //     if (orders[index].status == 'pending')
                      //       Expanded(
                      //         child: ElevatedButton(
                      //           onPressed: () {
                      //             Navigator.of(context).push(MaterialPageRoute(
                      //                 builder: (context) =>
                      //                     PaymentWebViewScreen(
                      //                         checkoutUrl: orders[index]
                      //                             .paymentUrl
                      //                             .toString())));
                      //           },
                      //           child: Text(
                      //             "Pay",
                      //             style: TextStyle(fontSize: 12),
                      //           ),
                      //         ),
                      //       ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
                itemCount: orders.length,
              );
            } else {
              // Display NoDataWidget if the result indicates failure
              return NoDataWidget(
                title:
                    'No orders found', // Display message when no orders are available
                imageWidget: const ErrorStateWidget(),
              );
            }
          },
          loadingWidget: _buildShimmer(), // Loading UI
          errorBuilder: (error) {
            // Handle errors by showing the NoDataWidget
            return NoDataWidget(
              title: error.toString(), // Display error message
              imageWidget: const ErrorStateWidget(),
              // retryText: 'Reload',
              // onRetry: () {}, // Retry logic
            );
          },
        ),
      ),
    );
  }

  Padding _buildShimmer() {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          ...List.generate(
            5,
            (index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: defaultPadding / 2),
                child: Row(
                  children: [
                    Skeleton(height: 60, width: 60),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Skeleton(height: 20, width: 300),
                          const SizedBox(height: defaultPadding / 2),
                          Skeleton(height: 20, width: 100),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
