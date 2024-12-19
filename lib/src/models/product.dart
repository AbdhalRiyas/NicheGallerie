class Product {
  final int id;

  final String name;

  final String permalink;

  final String type;

  final String shortDescription;

  final String stockStatus;

  final double price;

  final double regularPrice;

  final double? salePrice;

  final bool onSale;

  final List<String> images;

  final Map<dynamic, dynamic>? metadata;

  Product({
    required this.id,
    required this.name,
    required this.permalink,
    required this.type,
    required this.shortDescription,
    required this.stockStatus,
    required this.price,
    required this.regularPrice,
    required this.salePrice,
    required this.onSale,
    required this.images,
    required this.metadata,
  });

  factory Product.fromJson(Map<String, dynamic> product) => Product(
      id: product['id'],
      name: product['name'],
      permalink: product['permalink'],
      type: product['type'],
      shortDescription: product['short_description'],
      stockStatus: product['stock_status'],
      price: double.parse(product['price']),
      regularPrice: double.parse(product['regular_price']),
      salePrice: product['sale_price'] != null
          ? double.parse(product['sale_price'])
          : null,
      onSale: product['on_sale'],
      images: List<String>.from(product['images']),
      metadata: product['metadata']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'permalink': permalink,
        'type': type,
        'short_description': shortDescription,
        'stock_status': stockStatus,
        'price': price,
        'regular_price': regularPrice,
        'sale_price': salePrice,
        'on_sale': onSale,
        'images': images,
        'metadata': metadata,
      };
}
