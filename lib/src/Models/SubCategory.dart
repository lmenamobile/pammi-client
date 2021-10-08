class SubCategory {
  SubCategory({
    this.id,
    this.subcategory,
    this.status,
  });

  int? id;
  String? subcategory;
  String? status;

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
    id: json["id"],
    subcategory: json["subcategory"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "subcategory": subcategory,
    "status": status,
  };
}