// To parse this JSON data, do
//
//     final subCategoriesResponse = subCategoriesResponseFromJson(jsonString);

import 'dart:convert';

SubCategoriesResponse subCategoriesResponseFromJson(String str) => SubCategoriesResponse.fromJson(json.decode(str));

String subCategoriesResponseToJson(SubCategoriesResponse data) => json.encode(data.toJson());

class SubCategoriesResponse {
  SubCategoriesResponse({
    this.code,
    this.message,
    this.status,
    this.data,
  });

  int code;
  String message;
  bool status;
  Data data;

  SubCategoriesResponse.fromJson(Map<String, dynamic> json){
    code = json["code"];
    message = json["message"];
    status = json["status"];
    data = status ? Data.fromJson(json["data"]): null;
  }

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.totalPages,
    this.currentPage,
    this.subcategories,
  });

  int totalPages;
  int currentPage;
  List<Subcategory> subcategories;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalPages: json["totalPages"],
    currentPage: json["currentPage"],
    subcategories: List<Subcategory>.from(json["items"].map((x) => Subcategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalPages": totalPages,
    "currentPage": currentPage,
    "subcategories": List<dynamic>.from(subcategories.map((x) => x.toJson())),
  };
}

class Subcategory {
  Subcategory({
    this.id,
    this.subcategory,
    this.status,
  });

  int id;
  String subcategory;
  String status;

  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
    id: json["id"],
    subcategory: json["subcategory"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "subcategory": subcategory,
    "status": status,
  };
}
