
// To parse this JSON data, do
//
//     final categoriesResponse = categoriesResponseFromJson(jsonString);

import 'dart:convert';

CategoriesResponse categoriesResponseFromJson(String str) => CategoriesResponse.fromJson(json.decode(str));

String categoriesResponseToJson(CategoriesResponse data) => json.encode(data.toJson());

class CategoriesResponse {
  CategoriesResponse({
    this.code,
    this.message,
    this.status,
    this.data,
  });

  int code;
  String message;
  bool status;
  Data data;

  CategoriesResponse.fromJson(Map<String, dynamic> json) {
    code= json["code"];
    message= json["message"];
    status= json["status"];
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
    this.categories,
  });

  int totalPages;
  int currentPage;
  List<Category> categories;

   Data.fromJson(Map<String, dynamic> json) {
     totalPages = json["totalPages"];
     currentPage = json["currentPage"];
     categories = List<Category>.from(json["items"].map((x) => Category.fromJson(x)));
   }

  Map<String, dynamic> toJson() => {
    "totalPages": totalPages,
    "currentPage": currentPage,
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
  };
}

class Category {
  Category({
    this.id,
    this.category,
    this.color,
    this.image,
    this.status,
    this.selected
  });

  int id;
  String category;
  String color;
  String image;
  String status;
  bool selected;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    category: json["category"],
    color: json["color"],
    image: json["image"],
    status: json["status"],
    selected: false
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category": category,
    "color": color,
    "image": image,
    "status": status,
  };
}
