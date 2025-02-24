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
  final String? paymentUrl;

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
    this.paymentUrl,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        id: json['id'] ?? 0,
        dateCreated: json['date_created'] ?? '',
        status: json['status'] ?? '',
        total: json['total']?.toString() ?? '0', // Convert to String
        currency: json['currency'] ?? 'AED', // Default to 'AED' if null
        paymentMethod: json['payment_method_title'] ?? 'Not Specified',
        customerName: json['billing'] != null
            ? "${json['billing']['first_name'] ?? ''} ${json['billing']['last_name'] ?? ''}"
                .trim()
            : 'Unknown',
        customerEmail: json['billing']?['email'] ?? '',
        customerPhone: json['billing']?['phone'] ?? '',
        billingAddress: json['billing'] != null
            ? _formatAddress(json['billing'])
            : 'No Address',
        shippingMethod: (json['shipping_lines'] as List?)?.isNotEmpty == true
            ? json['shipping_lines'][0]['method_title'] ?? 'Not Specified'
            : 'Not Specified',
        items: (json['line_items'] as List?)
                ?.map((item) => OrderItem.fromJson(item))
                .toList() ??
            [],
        trackingNumber: (json['meta_data'] as List?)
                ?.firstWhere(
                  (meta) => meta['key'] == 'tracking_number',
                  orElse: () => {'value': 'Not created'},
                )['value']
                ?.toString() ??
            'Not created', // Ensure String conversion
        paymentUrl: json['payment_url'] ?? '');
  }

// Helper method to format address safely
  static String _formatAddress(Map<String, dynamic> billing) {
    return [
      billing['address_1'] ?? '',
      billing['address_2'] ?? '',
      billing['city'] ?? '',
      billing['state'] ?? '',
      billing['country'] ?? '',
      billing['postcode'] ?? ''
    ].where((e) => e.isNotEmpty).join(', '); // Remove empty values
  }
}

class OrderItem {
  final int id;
  final String name;
  final int productId;
  final int variationId;
  final int quantity;
  final String taxClass;
  final double subtotal;
  final double subtotalTax;
  final double total;
  final double totalTax;
  final List<dynamic> taxes;
  final List<dynamic> metaData;
  final String sku;
  final double price;
  final String imageUrl;

  OrderItem({
    required this.id,
    required this.name,
    required this.productId,
    required this.variationId,
    required this.quantity,
    required this.taxClass,
    required this.subtotal,
    required this.subtotalTax,
    required this.total,
    required this.totalTax,
    required this.taxes,
    required this.metaData,
    required this.sku,
    required this.price,
    required this.imageUrl,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      name: json['name'],
      productId: json['product_id'],
      variationId: json['variation_id'],
      quantity: json['quantity'],
      taxClass: json['tax_class'] ?? '',
      subtotal: double.tryParse(json['subtotal'].toString()) ?? 0.0,
      subtotalTax: double.tryParse(json['subtotal_tax'].toString()) ?? 0.0,
      total: double.tryParse(json['total'].toString()) ?? 0.0,
      totalTax: double.tryParse(json['total_tax'].toString()) ?? 0.0,
      taxes: json['taxes'] ?? [],
      metaData: json['meta_data'] ?? [],
      sku: json['sku'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      imageUrl: json['image'] != null ? json['image']['src'] : '',
    );
  }
}
