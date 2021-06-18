

import 'package:wawamko/src/Models/Product/ImageProduct.dart';

class Reference {
  Reference({
    this.id,
    this.sku,
    this.reference,
    this.price,
    this.iva,
    this.qty,
    this.color,
    this.images,
  });

  int id;
  String sku;
  String reference;
  String price;
  String iva;
  String qty;
  String color;
  List<ImageProduct> images;

  factory Reference.fromJson(Map<String, dynamic> json) => Reference(
    id: json["id"],
    sku: json["sku"],
    reference: json["reference"],
    price: json["price"].toString(),
    iva: json["iva"].toString(),
    qty: json["qty"].toString(),
    color: json["color"],
    images: List<ImageProduct>.from(json["images"].map((x) => ImageProduct.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sku": sku,
    "reference": reference,
    "price": price,
    "iva": iva,
    "qty": qty,
    "color": color,
    "images": List<dynamic>.from(images.map((x) => x.toJson())),
  };
}