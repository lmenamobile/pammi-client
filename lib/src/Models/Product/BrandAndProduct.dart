import 'package:wawamko/src/Models/Claim/DetailClaim.dart';

import 'BrandProvider.dart';

class BrandAndProduct {
  BrandAndProduct({
    this.id,
    this.sku,
    this.product,
    this.characteristics,
    this.linkVideo,
    this.conditions,
    this.featured,
    this.weight,
    this.volume,
    this.applyDevolution,
    this.warranty,
    this.brandProvider,
  });

  int? id;
  String? sku;
  String? product;
  String? characteristics;
  String? linkVideo;
  String? conditions;
  bool? featured;
  String? weight;
  String? volume;
  String? applyDevolution;
  Warranty? warranty;
  BrandProvider? brandProvider;

  factory BrandAndProduct.fromJson(Map<String, dynamic> json) => BrandAndProduct(
    id: json["id"],
    sku: json["sku"],
    product: json["product"],
    characteristics: json["characteristics"],
    linkVideo: json["linkVideo"],
    conditions: json["conditions"],
    featured: json["featured"],
    weight: json["weight"].toString(),
    volume: json["volume"].toString(),
    applyDevolution: json["applyDevolution"]??'',
    warranty: json["warranty"]==null?null:Warranty.fromJson(json["warranty"]),
    brandProvider:json["brandProvider"]==null?null: BrandProvider.fromJson(json["brandProvider"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sku": sku,
    "product": product,
    "characteristics": characteristics,
    "linkVideo": linkVideo,
    "conditions": conditions,
    "featured": featured,
    "weight": weight,
    "volume": volume,
    "brandProvider": brandProvider!.toJson(),
  };
}