class Category {
  final int id, parent;
  final String name, slug;
  final String image;

  Category(
      {required this.id,
      required this.parent,
      required this.name,
      required this.slug,
      required this.image});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      image: json['image'] != null ? json['image']['src'] : '',
      parent: json['parent']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'slug': slug,
        'image': image,
        'parent': parent,
      };
}
