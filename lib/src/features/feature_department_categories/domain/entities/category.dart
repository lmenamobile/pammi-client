


import '../domain.dart';

class Category {
  final int id;
  final String category;
  final String color;
  final String image;
  final List<SubCategory> subCategories;

  Category({
    required this.id,
    required this.category,
    required this.color,
    required this.image,
    this.subCategories = const [],
  });

 Category copyWith({
    int? id,
    String? category,
    String? color,
    String? image,
    List<SubCategory>? subCategories,
  }) {
    return Category(
      id: id ?? this.id,
      category: category ?? this.category,
      color: color ?? this.color,
      image: image ?? this.image,
      subCategories: subCategories ?? this.subCategories,
    );
  }

  @override
  String toString() {
    return 'Category(id: $id, category: $category, color: $color, image: $image)';
  }

}