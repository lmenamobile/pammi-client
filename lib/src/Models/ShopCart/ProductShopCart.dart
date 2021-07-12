import 'package:wawamko/src/Models/Product/Reference.dart';

class ProductShopCart {
  ProductShopCart({
    this.id,
    this.qty,
    this.reference,
  });

  int id;
  String qty;
  Reference reference;

  factory ProductShopCart.fromJson(Map<String, dynamic> json) => ProductShopCart(
    id: json["id"],
    qty: json["qty"].toString(),
    reference: Reference.fromJson(json["reference"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "qty": qty,
    "reference": reference.toJson(),
  };
}