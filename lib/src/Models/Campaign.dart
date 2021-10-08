import 'package:wawamko/src/Models/Product/Product.dart';

class Campaign {
  Campaign({
    this.id,
    this.campaign,
    this.image,
    this.type,
    this.ltsProducts
  });

  int? id;
  String? campaign;
  String? image;
  String? type;
  List<Product>? ltsProducts;

  factory Campaign.fromJson(Map<String, dynamic> json) => Campaign(
    id: json["id"],
    campaign: json["campaign"],
    image: json["image"],
    type: json["type"],
    ltsProducts: json["products"]==null?null:List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "campaign": campaign,
    "image": image,
    "type": type,
  };
}
