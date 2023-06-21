
import 'package:wawamko/src/Models/OfferHighlights.dart';

class Banners {
  Banners({
    this.id,
    this.name,
    this.url,
    this.position,
    this.image,
    this.type,
    this.offerHighlights
  });

  int? id;
  String? name;
  String? url;
  int? position;
  String? image;
  String? type;
  OfferHighlights? offerHighlights;

  factory Banners.fromJson(Map<String, dynamic> json) => Banners(
    id: json["id"],
    name: json["name"],
    url: json["url"],
    position: json["position"],
    image: json["image"],
    type: json["type"],
    offerHighlights:json["providerOffer"]==null?null:OfferHighlights.fromJson(json["providerOffer"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "url": url,
    "position": position,
    "image": image,
    "type": type,
  };
}