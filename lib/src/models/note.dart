class Note {
  final String name;
  final String link;
  final String image;
  final String imageUrl;
  final bool isFeatured;

  Note({
    required this.name,
    required this.link,
    required this.image,
    required this.imageUrl,
    this.isFeatured = false,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      name: json['name'],
      link: json['link'],
      image: json['image'],
      imageUrl: json['image_url'],
      isFeatured: json['is_featured'] == 1,
    );
  }
}
