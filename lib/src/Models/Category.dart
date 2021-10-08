
class Category {
  Category({
    this.id,
    this.category,
    this.color,
    this.image,
    this.status,
  });

  int? id;
  String? category;
  String? color;
  String? image;
  String? status;
  bool isSelected = false;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    category: json["category"],
    color: json["color"],
    image: json["image"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category": category,
    "color": color,
    "image": image,
    "status": status,
  };
}