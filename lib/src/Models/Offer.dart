import 'package:wawamko/src/Models/Product/ProductOffer.dart';

import 'Product/BrandProvider.dart';

class Offer {
  Offer({
    this.id,
    this.name,
    this.offerType,
    this.discountValue,
    this.imageBanner,
    this.brandProvider,
    this.baseProducts,
    this.promotionProducts
  });

  int? id;
  String? name;
  String? offerType;
  String? discountValue;
  String? imageBanner;
  BrandProvider? brandProvider;
  List<ProductOffer>? baseProducts;
  List<ProductOffer>? promotionProducts;

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
    id: json["id"],
    name: json["name"],
    offerType: json["offerType"],
    discountValue: json["discountValue"].toString(),
    imageBanner: json["imageBanner"],
    brandProvider: json["brandProvider"]==null?null:BrandProvider.fromJson(json["brandProvider"]),
    baseProducts: List<ProductOffer>.from(json["baseProducts"].map((x) => ProductOffer.fromJson(x))),
    promotionProducts:  List<ProductOffer>.from(json["promotionProducts"].map((x) => ProductOffer.fromJson(x))),
  );


}