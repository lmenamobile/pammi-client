class GiftCard {
  GiftCard({
    this.id,
    this.name,
    this.value,
    this.type,
  });

  int id;
  String name;
  String value;
  String type;

  factory GiftCard.fromJson(Map<String, dynamic> json) => GiftCard(
    id: json["id"],
    name: json["name"],
    value: json["value"].toString(),
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "value": value,
    "type": type,
  };
}
