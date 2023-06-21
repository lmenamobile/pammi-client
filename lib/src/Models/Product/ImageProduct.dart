class ImageProduct {
  ImageProduct({
    this.id,
    this.url,
    this.type,
  });

  int? id;
  String? url;
  String? type;

  factory ImageProduct.fromJson(Map<String, dynamic> json) => ImageProduct(
    id: json["id"],
    url: json["url"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "url": url,
    "type": type,
  };
}