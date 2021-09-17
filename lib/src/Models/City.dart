import 'package:wawamko/src/Models/CountryUser.dart';

class City {
  City({
    this.id,
    this.name,
    this.countryUser
  });

  int id;
  String name;
  CountryUser countryUser;

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json["id"],
    name: json["name"],
    countryUser:json["state"]==null?null:CountryUser.fromJson(json["state"]["country"]),

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
