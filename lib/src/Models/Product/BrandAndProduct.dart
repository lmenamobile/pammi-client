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