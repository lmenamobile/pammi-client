class Address {
  Address({
    this.id,
    this.address,
    this.latitude,
    this.longitude,
    this.status,
    this.createdAt,
    this.complement,
    this.name
  });

  int? id;
  String? address;
  String? latitude;
  String? longitude;
  String? status;
  String? complement;
  String? name;
  DateTime? createdAt;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"],
    address: json["address"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    status: json["status"],
    complement: json["complement"],
    name:json["name"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "status": status,
    "createdAt": createdAt!.toIso8601String(),
  };
}