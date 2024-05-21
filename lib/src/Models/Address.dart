class Address {
  Address({
    this.id,
    this.address,
    this.latitude,
    this.longitude,
    this.principal,
    this.status,
    this.createdAt,
    this.complement,
    this.name,
    this.city
  });

  int? id;
  String? address;
  String? latitude;
  String? longitude;
  bool? principal;
  String? status;
  String? complement;
  String? name;
  City? city;
  DateTime? createdAt;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"],
    address: json["address"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    principal: json["principal"] == null ? null : json["principal"],
    status: json["status"],
    complement: json["complement"],
    name:json["name"],
    city: json["city"] == null ? null : City.fromJson(json["city"]),
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "principal": principal == null ? null : principal,
    "status": status,
    "city": city == null ? null : city!.toJson(),
    "createdAt": createdAt!.toIso8601String(),
  };
}

class City {
  City({
    this.id,
    this.name,
    this.name2,
    this.dane,
  });

  int? id;
  String? name;
  String? name2;
  String? dane;

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    name2: json["name2"] == null ? null : json["name2"],
    dane: json["dane"] == null ? null : json["dane"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "name2": name2 == null ? null : name2,
    "dane": dane == null ? null : dane,
  };
}