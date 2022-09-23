import 'dart:convert';

class ThemesResponse {
  ThemesResponse({
    this.code,
    this.status,
    this.data,
  });

  int? code;
  bool? status;
  Data? data;

  factory ThemesResponse.fromJson(Map<String, dynamic> json) => ThemesResponse(
    code: json["code"] == null ? null : json["code"],
    status: json["status"] == null ? null : json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "status": status == null ? null : status,
    "data": data == null ? null : data!.toJson(),
  };
}

class Data {
  Data({
    this.totalPages,
    this.currentPage,
    this.items,
  });

  int? totalPages;
  int? currentPage;
  List<ItemTheme>? items;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalPages: json["totalPages"] == null ? null : json["totalPages"],
    currentPage: json["currentPage"] == null ? null : json["currentPage"],
    items: json["items"] == null ? null : List<ItemTheme>.from(json["items"].map((x) => ItemTheme.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalPages": totalPages == null ? null : totalPages,
    "currentPage": currentPage == null ? null : currentPage,
    "items": items == null ? null : List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}

class ItemTheme {
  ItemTheme({
    this.id,
    this.theme,
    this.subthemes,
    this.status,
    this.createdAt,
  });

  int? id;
  String? theme;
  List<SubTheme>? subthemes;
  String? status;
  DateTime? createdAt;

  factory ItemTheme.fromJson(Map<String, dynamic> json) => ItemTheme(
    id: json["id"] == null ? null : json["id"],
    theme: json["theme"] == null ? null : json["theme"],
    subthemes: json["subthemes"] == null ? null : List<SubTheme>.from(json["subthemes"].map((x) => SubTheme.fromJson(x))),
    status: json["status"] == null ? null : json["status"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "theme": theme == null ? null : theme,
    "subthemes": subthemes == null ? null : List<dynamic>.from(subthemes!.map((x) => x.toJson())),
    "status": status == null ? null : status,
    "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
  };
}

class SubTheme {
  SubTheme({
    this.id,
    this.subtheme,
    this.image,
    this.options,
  });

  int? id;
  String? subtheme;
  String? image;
  Options? options;

  factory SubTheme.fromJson(Map<String, dynamic> json) => SubTheme(
    id: json["id"] == null ? null : json["id"],
    subtheme: json["subtheme"] == null ? null : json["subtheme"],
    image: json["image"] == null ? null : json["image"],
    options: json["options"] == null ? null : Options.fromJson(json["options"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "subtheme": subtheme == null ? null : subtheme,
    "image": image == null ? null : image,
    "options": options == null ? null : options!.toJson(),
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

  factory Options.fromRawJson(String str) => Options.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Options.fromJson(Map<String, dynamic> json) => Options(
    status: json["status"] == null ? null : json["status"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
    "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
  };
}




