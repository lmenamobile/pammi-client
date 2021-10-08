
class Brand {
  Brand({
    this.id,
    this.brand,
    this.image,
  });

  int? id;
  String? brand;
  String? image;

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
    id: json["id"],
    brand: json["brand"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "brand": brand,
    "image": image,
  };
}