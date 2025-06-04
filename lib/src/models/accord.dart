// {
//     "name": "Cannabis",
//     "accord_id": "1235",
//     "slug": "cannabis",
//     "image_url": "https://staging23.nichegallerie.com/wp-content/uploads/2023/05/Cannabis-perfume-note.webp",
//     "is_featured": 1
// }

class Accord {
  final String name;
  final String link;
  final String image;
  final String imageUrl;
  final bool isFeatured;

  Accord({
    required this.name,
    required this.link,
    required this.image,
    required this.imageUrl,
    this.isFeatured = false,
  });

  factory Accord.fromJson(Map<String, dynamic> json) {
    return Accord(
      name: json['name'],
      link: json['link'],
      image: json['image'],
      imageUrl: json['image_url'],
      isFeatured: json['is_featured'] == 1,
    );
  }
}
