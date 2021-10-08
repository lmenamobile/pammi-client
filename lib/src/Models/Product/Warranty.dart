class Warranty {
  Warranty({
    this.id,
    this.warrantyProduct,
  });

  int? id;
  String? warrantyProduct;

  factory Warranty.fromJson(Map<String, dynamic> json) => Warranty(
    id: json["id"],
    warrantyProduct: json["warrantyProduct"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "warrantyProduct": warrantyProduct,
  };
}
