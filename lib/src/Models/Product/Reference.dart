

import 'package:wawamko/src/Models/Product/BrandAndProduct.dart';
import 'package:wawamko/src/Models/Product/ImageProduct.dart';
import 'package:wawamko/src/Models/ShopCart/TotalProductOffer.dart';

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
    this.qualification,
    this.isSelected,
    this.brandAndProduct,
    this.isFavorite,
    this.totalProductOffer
  });

  int id;
  String sku;
  String reference;
  String price;
  String iva;
  String qty;
  String color;
  String qualification;
  List<ImageProduct> images;
  bool isSelected = false;
  bool isFavorite = false;
  BrandAndProduct brandAndProduct;
  TotalProductOffer totalProductOffer;

  factory Reference.fromJson(Map<String, dynamic> json) => Reference(
    id: json["id"],
    sku: json["sku"],
    reference: json["reference"],
    price: json["price"].toString(),
    iva: json["iva"].toString(),
    qty: json["qty"].toString(),
    color: json["color"],
    isSelected: false,
    isFavorite: json["liked"],
    qualification: json["qualification"]==null?'0':json["qualification"].toString(),
    images:json["images"]==null?null: List<ImageProduct>.from(json["images"].map((x) => ImageProduct.fromJson(x))),
    brandAndProduct: json["brandProviderProduct"]==null?null:BrandAndProduct.fromJson(json["brandProviderProduct"]),
    totalProductOffer: json["offer"]==null?null:TotalProductOffer.fromJson(json["offer"]),
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