class Campaign {
  Campaign({
    this.id,
    this.campaign,
    this.image,
    this.type,
  });

  int id;
  String campaign;
  String image;
  String type;

  factory Campaign.fromJson(Map<String, dynamic> json) => Campaign(
    id: json["id"],
    campaign: json["campaign"],
    image: json["image"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "campaign": campaign,
    "image": image,
    "type": type,
  };
}
