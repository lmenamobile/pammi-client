
class CountryUser {
  CountryUser({
    this.id,
    this.country,
    this.callingCode,
    this.flag,
    this.currency,
  });

  String id;
  String country;
  String callingCode;
  String flag;
  String currency;

  factory CountryUser.fromJson(Map<String, dynamic> json) => CountryUser(
    id: json["id"],
    country: json["country"],
    callingCode: json["callingCode"],
    flag: json["flag"],
    currency: json["currency"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "country": country,
    "callingCode": callingCode,
    "flag": flag,
    "currency": currency,
  };
}
