// To parse this JSON data, do
//
//     final getAddressResponse = getAddressResponseFromJson(jsonString);

import 'dart:convert';

import 'package:wawamko/src/Models/Address.dart';

GetAddressResponse getAddressResponseFromJson(String str) => GetAddressResponse.fromJson(json.decode(str));

String getAddressResponseToJson(GetAddressResponse data) => json.encode(data.toJson());

class GetAddressResponse {
  GetAddressResponse({
    this.code,
    this.message,
    this.status,
    this.data,
  });

  int? code;
  String? message;
  bool? status;
  Data? data;

  GetAddressResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
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
    this.totalPages,
    this.currentPage,
    this.addresses,
  });

  int? totalPages;
  int? currentPage;
  List<Address>? addresses;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalPages: json["totalPages"],
    currentPage: json["currentPage"],
    addresses: List<Address>.from(json["items"].map((x) => Address.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalPages": totalPages,
    "currentPage": currentPage,
    "addresses": List<dynamic>.from(addresses!.map((x) => x.toJson())),
  };
}




class ChangeStatusAddressResponse {
  ChangeStatusAddressResponse({
    this.message,
    this.status,
    this.code
  });

  int? code;
  String? message;
  bool? status;


  factory ChangeStatusAddressResponse.fromJson(Map<String, dynamic> json) => ChangeStatusAddressResponse(
    code: json["code"],
    status: json["status"],
    message: json["message"],

  );


}
