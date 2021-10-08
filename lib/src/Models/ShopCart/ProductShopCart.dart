import 'package:wawamko/src/Models/GiftCard.dart';
import 'package:wawamko/src/Models/Product/Reference.dart';
import 'package:wawamko/src/Models/ShopCart/Offer.dart';

class ProductShopCart {
  ProductShopCart({
    this.id,
    this.qty,
    this.reference,
    this.offer,
    this.giftCard
  });

  int? id;
  String? qty;
  Reference? reference;
  Offer? offer;
  GiftCard? giftCard;

  factory ProductShopCart.fromJson(Map<String, dynamic> json) => ProductShopCart(
    id: json["id"],
    qty: json["qty"].toString(),
    reference: json["reference"] == null?null:Reference.fromJson(json["reference"]),
    offer: json["offer"]==null?null: Offer.fromJson(json["offer"]),
    giftCard:  json["giftcard"]==null?null: GiftCard.fromJson(json["giftcard"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "qty": qty,
    "reference": reference!.toJson(),
  };
}