
class Category {
  final int id;
  final String category;
  final String color;
  final String image;

  Category({
    required this.id,
    required this.category,
    required this.color,
    required this.image,
  });

 Category copyWith({
    int? id,
    String? category,
    String? color,
    String? image,
  }) {
    return Category(
      id: id ?? this.id,
      category: category ?? this.category,
      color: color ?? this.color,
      image: image ?? this.image,
    );
  }

  @override
  String toString() {
    return 'Category(id: $id, category: $category, color: $color, image: $image)';
  }

}