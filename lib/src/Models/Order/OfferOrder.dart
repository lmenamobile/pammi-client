
import 'package:wawamko/src/Models/ShopCart/ProductOfferCart.dart';

class OfferOrder {
  OfferOrder({
    this.id,
    this.name,
    this.offerType,
    this.baseProducts,
   /// this.brandProvider,
  });

  int? id;
  String? name;
  String? offerType;
  List<ProductOfferCart>? baseProducts;
 // BrandProvider? brandProvider;

  factory OfferOrder.fromJson(Map<String, dynamic> json) => OfferOrder(
    id: json["id"],
    name: json["name"],
    offerType: json["offerType"],
    baseProducts: List<ProductOfferCart>.from(json["baseProducts"].map((x) => ProductOfferCart.fromJson(x))),
   // brandProvider: json["brandProvider"]==null?null: BrandProvider.fromJson(json["brandProvider"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "offerType": offerType,
    "baseProducts": List<dynamic>.from(baseProducts!.map((x) => x.toJson())),

  };
}