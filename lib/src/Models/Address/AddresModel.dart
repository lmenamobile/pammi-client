// To parse this JSON data, do
//
//     final addressResponse = addressResponseFromJson(jsonString);

import 'dart:convert';

AddressResponse addressResponseFromJson(String str) => AddressResponse.fromJson(json.decode(str));

String addressResponseToJson(AddressResponse data) => json.encode(data.toJson());

class AddressResponse {
  AddressResponse({
    this.code,
    this.message,
    this.status,
    this.data,
  });

  int? code;
  String? message;
  bool? status;
  Data? data;

   AddressResponse.fromJson(Map<String, dynamic> json){
     code= json["code"];
     message = json["message"];
     status = json["status"];
     data = status! ? Data.fromJson(json["data"]) : null;
   }

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "status": status,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.savedAddress,
  });

  SavedAddress? savedAddress;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    savedAddress: SavedAddress.fromJson(json["savedAddress"]),
  );

  Map<String, dynamic> toJson() => {
    "savedAddress": savedAddress!.toJson(),
  };
}

class SavedAddress {
  SavedAddress({
    this.address,
    this.latitude,
    this.longitude,
    this.user,
    this.id,
    this.options,
  });

  String? address;
  String? latitude;
  String? longitude;
  String? user;
  int? id;
  Options? options;

  factory SavedAddress.fromJson(Map<String, dynamic> json) => SavedAddress(
    address: json["address"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    user: json["user"],
    id: json["id"],
    options: Options.fromJson(json["options"]),
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "user": user,
    "id": id,
    "options": options!.toJson(),
  };
}

class Options {
  Options({
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Options.fromJson(Map<String, dynamic> json) => Options(
    status: json["status"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
  };
}
