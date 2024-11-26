import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 0) // Assign a unique typeId for Hive
class Product {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String permalink;

  @HiveField(3)
  final String type;

  @HiveField(4)
  final String shortDescription;

  @HiveField(5)
  final String stockStatus;

  @HiveField(6)
  final double price;

  @HiveField(7)
  final double regularPrice;

  @HiveField(8)
  final double? salePrice;

  @HiveField(9)
  final bool onSale;

  @HiveField(10)
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
        salePrice: product['sale_price'] != null
            ? double.parse(product['sale_price'])
            : null,
        onSale: product['on_sale'],
        images: List<String>.from(product['images']),
      );

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
      };
}
