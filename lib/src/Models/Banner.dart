
class Banners {
  Banners({
    this.id,
    this.name,
    this.url,
    this.position,
    this.image,
    this.type,
  });

  int id;
  String name;
  String url;
  int position;
  String image;
  String type;

  factory Banners.fromJson(Map<String, dynamic> json) => Banners(
    id: json["id"],
    name: json["name"],
    url: json["url"],
    position: json["position"],
    image: json["image"],
    type: json["type"],
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