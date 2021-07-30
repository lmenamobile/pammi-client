
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
    this.offerOrder
  });

  int id;
  String name;
  String qty;
  String price;
  String total;
  Reference reference;
  OfferOrder offerOrder;

  factory ProductProvider.fromJson(Map<String, dynamic> json) => ProductProvider(
    id: json["id"],
    name: json["name"],
    qty: json["qty"].toString(),
    price: json["price"].toString(),
    total: json["total"].toString(),
    reference: json["reference"] == null ? null : Reference.fromJson(json["reference"]),
    offerOrder: json["offer"] == null ? null : OfferOrder.fromJson(json["offer"]),
  );


}