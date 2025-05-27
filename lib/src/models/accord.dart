// {
//     "name": "Cannabis",
//     "accord_id": "1235",
//     "slug": "cannabis",
//     "image_url": "https://staging23.nichegallerie.com/wp-content/uploads/2023/05/Cannabis-perfume-note.webp",
//     "is_featured": 1
// }

class Accord {
  final String name;
  final String accordId;
  final String slug;
  final String imageUrl;
  final bool isFeatured;

  Accord({
    required this.name,
    required this.accordId,
    required this.slug,
    required this.imageUrl,
    this.isFeatured = false,
  });

  factory Accord.fromJson(Map<String, dynamic> json) {
    return Accord(
      name: json['name'],
      accordId: json['accord_id'],
      slug: json['slug'],
      imageUrl: json['image_url'],
      isFeatured: json['is_featured'] == 1,
    );
  }
}
