import 'package:wawamko/src/Models/Product/BrandProvider.dart';

import 'Product/Reference.dart';
import 'SubCategory.dart';

class OfferHighlights {
  OfferHighlights({
    this.id,
    this.name,
    this.offerType,
    this.discountValue,
    this.imageBanner,
    this.brandProvider,
    this.reference,
    this.subcategory,
  });

  int id;
  String name;
  String offerType;
  String discountValue;
  String imageBanner;
  String brandProvider;
  Reference reference;
  SubCategory subcategory;

  factory OfferHighlights.fromJson(Map<String, dynamic> json) => OfferHighlights(
    id: json["id"],
    name: json["name"],
    offerType: json["offerType"],
    discountValue: json["discountValue"].toString(),
    imageBanner: json["imageBanner"],
    brandProvider:json["brandProvider"]==null?null: json["brandProvider"]["id"].toString(),
    reference: json["reference"]==null?null:Reference.fromJson(json["reference"]),
    subcategory: json["subcategory"]==null?null:SubCategory.fromJson(json["subcategory"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "offerType": offerType,
    "discountValue": discountValue,
    "imageBanner": imageBanner,
    "reference": reference.toJson(),
    "subcategory": subcategory.toJson(),
  };
}