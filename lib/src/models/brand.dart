class Brand {
  final String name;
  final String brandId;
  final String slug;
  final String imageUrl;
  final bool isFeatured;

  Brand({
    required this.name,
    required this.brandId,
    required this.slug,
    required this.imageUrl,
    this.isFeatured = false,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      name: json['name'],
      brandId: json['brand_id'],
      slug: json['slug'],
      imageUrl: json['image_url'],
      isFeatured: json['is_featured'] == 1,
    );
  }
}
