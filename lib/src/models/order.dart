class Order {
  final int id;
  final String dateCreated;
  final String status;
  final String total;
  final String currency;
  final String paymentMethod;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String billingAddress;
  final String shippingMethod;
  final List<OrderItem> items;
  final String trackingNumber;

  Order({
    required this.id,
    required this.dateCreated,
    required this.status,
    required this.total,
    required this.currency,
    required this.paymentMethod,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.billingAddress,
    required this.shippingMethod,
    required this.items,
    required this.trackingNumber,
  });

  // Factory to parse JSON from WooCommerce API
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      dateCreated: json['date_created'] ?? '',
      status: json['status'] ?? '',
      total: json['total'] ?? '0',
      currency: json['currency'] ?? '',
      paymentMethod: json['payment_method_title'] ?? '',
      customerName:
          " ${json['billing']['first_name']} ${json['billing']['last_name']}",
      customerEmail: json['billing']['email'] ?? '',
      customerPhone: json['billing']['phone'] ?? '',
      billingAddress: _formatAddress(json['billing']),
      shippingMethod: json['shipping_lines'].isNotEmpty
          ? json['shipping_lines'][0]['method_title'] ?? ''
          : 'Not Specified',
      items: (json['line_items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      trackingNumber: json['meta_data'].firstWhere(
          (meta) => meta['key'] == 'tracking_number',
          orElse: () => {'value': 'Not created'})['value'],
    );
  }

  // Helper method to format address
  static String _formatAddress(Map<String, dynamic> billing) {
    return '${billing['address_1']}, ${billing['address_2']}, ${billing['city']}, ${billing['state']}, ${billing['country']} - ${billing['postcode']}';
  }
}

class OrderItem {
  final String name;
  final int quantity;
  final String total;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.total,
  });

  // Factory to parse JSON for items
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      name: json['name'],
      quantity: json['quantity'],
      total: json['total'],
    );
  }
}
