import 'package:wawamko/src/Models/Product/Reference.dart';
import 'package:wawamko/src/Models/ShopCart/Offer.dart';

class ProductShopCart {
  ProductShopCart({
    this.id,
    this.qty,
    this.reference,
    this.offer
  });

  int id;
  String qty;
  Reference reference;
  Offer offer;

  factory ProductShopCart.fromJson(Map<String, dynamic> json) => ProductShopCart(
    id: json["id"],
    qty: json["qty"].toString(),
    reference: json["reference"] == null?null:Reference.fromJson(json["reference"]),
    offer: json["offer"]==null?null: Offer.fromJson(json["offer"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "qty": qty,
    "reference": reference.toJson(),
  };
}