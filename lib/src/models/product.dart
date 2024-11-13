class Product {
  final int id;
  final String name, permalink, type, shortDescription, stockStatus;
  final double price, regularPrice, salePrice;
  final bool onSale;
  final List<String> images;

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
        salePrice: double.parse(product['sale_price']),
        onSale: product['on_sale'],
        images: List<String>.from(product['images']),
      );
}
