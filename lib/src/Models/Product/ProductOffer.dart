import 'Reference.dart';

class ProductOffer {
  ProductOffer({
    this.id,
    this.reference,
  });

  int? id;
  Reference? reference;

  factory ProductOffer.fromJson(Map<String, dynamic> json) => ProductOffer(
    id: json["id"],
    reference: Reference.fromJson(json["reference"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "reference": reference!.toJson(),
  };
}