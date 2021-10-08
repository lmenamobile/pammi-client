
import 'package:wawamko/src/Models/GiftCard.dart';
import 'package:wawamko/src/Models/Product/Reference.dart';

import 'OfferOrder.dart';

class ProductProvider {
  ProductProvider({
    this.id,
    this.name,
    this.qty,
    this.price,
    this.total,
    this.reference,
    this.offerOrder,
    this.giftCard
  });

  int? id;
  String? name;
  String? qty;
  String? price;
  String? total;
  Reference? reference;
  OfferOrder? offerOrder;
  GiftCard? giftCard;

  factory ProductProvider.fromJson(Map<String, dynamic> json) => ProductProvider(
    id: json["id"],
    name: json["name"],
    qty: json["qty"].toString(),
    price: json["price"].toString(),
    total: json["total"].toString(),
    reference: json["reference"] == null ? null : Reference.fromJson(json["reference"]),
    offerOrder: json["offer"] == null ? null : OfferOrder.fromJson(json["offer"]),
    giftCard: json["giftcard"] == null ? null : GiftCard.fromJson(json["giftcard"]),
  );


}