import 'ProductOfferCart.dart';

class Offer {
  Offer({
    this.id,
    this.name,
    this.offerType,
    this.baseProducts,
    this.promotionProducts,
  });

  int? id;
  String? name;
  String? offerType;
  List<ProductOfferCart>? baseProducts;
  List<ProductOfferCart>? promotionProducts;

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
    id: json["id"],
    name: json["name"],
    offerType: json["offerType"],
    baseProducts: List<ProductOfferCart>.from(json["baseProducts"].map((x) => ProductOfferCart.fromJson(x))),
    promotionProducts: List<ProductOfferCart>.from(json["promotionProducts"].map((x) => ProductOfferCart.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "offerType": offerType,
    "baseProducts": List<dynamic>.from(baseProducts!.map((x) => x.toJson())),
    "promotionProducts": List<dynamic>.from(promotionProducts!.map((x) => x.toJson())),
  };
}