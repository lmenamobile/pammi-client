import 'Reference.dart';

class ProductFavorite {
  ProductFavorite({
    this.id,
    this.reference,
  });

  int id;
  Reference reference;

  factory ProductFavorite.fromJson(Map<String, dynamic> json) => ProductFavorite(
    id: json["id"],
    reference: Reference.fromJson(json["reference"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "reference": reference.toJson(),
  };
}