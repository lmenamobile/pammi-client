
class Brand {
  final int id;
  final String brand;
  final String image;

  Brand({
    required this.id,
    required this.brand,
    required this.image,
  });

  Brand copyWith({
    int? id,
    String? brand,
    String? image,
  }) {
    return Brand(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      image: image ?? this.image,
    );
  }

  @override
  String toString() {
    return 'Brand(id: $id, brand: $brand, image: $image)';
  }
}