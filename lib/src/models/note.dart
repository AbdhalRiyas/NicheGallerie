class Note {
  final String name;
  final String noteId;
  final String slug;
  final String imageUrl;
  final bool isFeatured;

  Note({
    required this.name,
    required this.noteId,
    required this.slug,
    required this.imageUrl,
    this.isFeatured = false,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      name: json['name'],
      noteId: json['brand_id'],
      slug: json['slug'],
      imageUrl: json['image_url'],
      isFeatured: json['is_featured'] == 1,
    );
  }
}
