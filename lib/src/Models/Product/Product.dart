import 'BrandProvider.dart';
import 'Reference.dart';
import 'Warranty.dart';

class Product {
  Product({
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
    this.warranty,
    this.references,
  });

  int id;
  String sku;
  String product;
  String characteristics;
  String linkVideo;
  String conditions;
  bool featured;
  String weight;
  String volume;
  BrandProvider brandProvider;
  Warranty warranty;
  List<Reference> references;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    sku: json["sku"],
    product: json["product"],
    characteristics: json["characteristics"],
    linkVideo: json["linkVideo"],
    conditions: json["conditions"],
    featured: json["featured"],
    weight: json["weight"],
    volume: json["volume"],
    brandProvider: BrandProvider.fromJson(json["brandProvider"]),
    warranty: Warranty.fromJson(json["warranty"]),
    references: List<Reference>.from(json["references"].map((x) => Reference.fromJson(x))),
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
    "brandProvider": brandProvider.toJson(),
    "warranty": warranty.toJson(),
    "references": List<dynamic>.from(references.map((x) => x.toJson())),
  };
}