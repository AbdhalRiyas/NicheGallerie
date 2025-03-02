import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/src/config/app_config.dart';
import 'package:shop/src/models/currency.dart';
import 'package:shop/src/models/order.dart';
import 'package:shop/src/repositories/order_repository.dart';
import 'package:shop/src/screens/checkout/views/payment_webview_screen.dart';
import 'package:shop/src/utils/currency_formatter.dart';
import 'package:shop/src/utils/result.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;
  final String? paymentUrl;
  const OrderDetailScreen({super.key, required this.orderId, this.paymentUrl});

  @override
  Widget build(BuildContext context) {
    final OrderRepository orderRepository = OrderRepository();

    return Scaffold(
      appBar: AppBar(title: Text("Order #$orderId")),
      body: FutureBuilder<Result>(
        future: orderRepository.fetchOrderById(orderId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.data!.isSuccess) {
            return Center(child: Text("Failed to load order details"));
          }

          Order order = snapshot.data!.data;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderSummary(order),
                Divider(),
                _buildOrderItems(context, order, order.items),
                Divider(),
                _buildCustomerDetails(order),
                SizedBox(height: 16),
                _buildActionButtons(context, order),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderSummary(Order order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Order Status: ${order.status}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(
            "Date: ${DateFormat('MMMM d, yyyy').format(DateTime.parse(order.dateCreated))}"),
        Text("Total: ${order.currency} ${order.total}"),
      ],
    );
  }

  Widget _buildOrderItems(
      BuildContext context, Order order, List<OrderItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Items",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...items.map((item) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(item.name, style: TextStyle(fontSize: 12)),
              subtitle: Text("Quantity: ${item.quantity}",
                  style: TextStyle(fontSize: 12)),
              trailing: Text(formatCurrency(
                  item.price,
                  Currency.fromJson(
                      context.read<AppConfig>().preferredCurrency))),
            ))
      ],
    );
  }

  Widget _buildCustomerDetails(Order order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Customer Details",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text("Name: ${order.customerName}"),
        Text("Email: ${order.customerEmail}"),
        Text("Address: ${order.billingAddress}"),
        Text("Phone: ${order.customerPhone}"),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, Order order) {
    return Row(
      children: [
        if (order.status == 'pending')
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      PaymentWebViewScreen(checkoutUrl: order.paymentUrl!))),
              child: Text("Pay"),
            ),
          ),
        // SizedBox(width: 8),
        // Expanded(
        //   child: ElevatedButton(
        //     onPressed: () {},
        //     child: Text("Order Again"),
        //   ),
        // ),
      ],
    );
  }
}
