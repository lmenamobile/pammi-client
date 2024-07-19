import 'package:wawamko/src/Models/Product/ImageProduct.dart';


import '../../features/feature_products/domain/domain.dart';
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
    //this.warranty,
    this.references = const [],
    this.service,
    this.images
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
  //Warranty? warranty;
  bool? service;
  List<Reference> references = [];
  List<ImageProduct>? images;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    sku: json["sku"],
    product: json["product"],
    characteristics: json["characteristics"],
    linkVideo: json["linkVideo"],
    conditions: json["conditions"],
    featured: json["featured"],
    service: json["service"],
    weight: json["weight"].toString(),
    volume: json["volume"].toString(),
    //brandProvider: BrandProvider.fromJson(json["brandProvider"]),
    //warranty: Warranty.fromJson(json["warranty"]),
    images:json["images"]==null?[]:List<ImageProduct>.from(json["images"].map((x) => x==null?null:ImageProduct.fromJson(x))),
    references:json["references"]==null?[]: List<Reference>.from(json["references"].map((x) => x==null?null:Reference.fromJson(x))),
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

    //"warranty": warranty!.toJson(),
    "references": List<dynamic>.from(references.map((x) => x.toJson())),
    "images": List<dynamic>.from(images!.map((x) => x.toJson())),
    "service": service
  };
}