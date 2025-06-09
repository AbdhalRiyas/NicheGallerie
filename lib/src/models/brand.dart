class Brand {
  final String name;
  final String slug;
  final String imageUrl;

  Brand({
    required this.name,
    required this.slug,
    required this.imageUrl,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      name: json['name'],
      slug: json['slug'],
      imageUrl: json['image_url'],
    );
  }
}
