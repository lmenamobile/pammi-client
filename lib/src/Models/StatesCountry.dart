
class StatesCountry{
  int id;
  String name;
  int totalCities;
  String status;

  StatesCountry({
    this.id,
    this.name,
    this.totalCities,
    this.status
  });

  factory StatesCountry.fromJson(Map<String, dynamic> json) => StatesCountry(
    id: json["id"],
    name: json["name"],
    status: json["status"],
    totalCities: json["totalCities"],
  );

}