// To parse this JSON data, do
//
//     final responsePqrs = responsePqrsFromJson(jsonString);

import 'dart:convert';

ResponsePqrs responsePqrsFromJson(String str) => ResponsePqrs.fromJson(json.decode(str));

String responsePqrsToJson(ResponsePqrs data) => json.encode(data.toJson());

class ResponsePqrs {
  ResponsePqrs({
    this.data,
  });

  Data? data;

  factory ResponsePqrs.fromJson(Map<String, dynamic> json) => ResponsePqrs(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
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
  List<ItemPqrs>? items;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalPages: json["totalPages"],
    currentPage: json["currentPage"],
    items: List<ItemPqrs>.from(json["items"].map((x) => ItemPqrs.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalPages": totalPages,
    "currentPage": currentPage,
    "items": List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}

class ItemPqrs {
  ItemPqrs({
    this.id,
    this.supportType,
    this.subject,
    this.message,
    this.identity,
    this.status,
    this.createdAt,
  });

  int? id;
  String? supportType;
  String? subject;
  String? message;
  bool? identity;
  String? status;
  DateTime? createdAt;

  factory ItemPqrs.fromJson(Map<String, dynamic> json) => ItemPqrs(
    id: json["id"],
    supportType: json["supportType"],
    subject: json["subject"],
    message: json["message"],
    identity: json["identity"],
    status: json["status"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "supportType": supportType,
    "subject": subject,
    "message": message,
    "identity": identity,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
  };
}



ResponseCreatePqrs responseCreatePqrsFromJson(String str) => ResponseCreatePqrs.fromJson(json.decode(str));

String responseCreatePqrsToJson(ResponseCreatePqrs data) => json.encode(data.toJson());

class ResponseCreatePqrs {
  ResponseCreatePqrs({
    this.data,
  });

  DataCreatePqrs? data;

  factory ResponseCreatePqrs.fromJson(Map<String, dynamic> json) => ResponseCreatePqrs(
    data: DataCreatePqrs.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
  };
}

class DataCreatePqrs {
  DataCreatePqrs({
    this.savedPqrs,
  });

  SavedPqrs? savedPqrs;

  factory DataCreatePqrs.fromJson(Map<String, dynamic> json) => DataCreatePqrs(
    savedPqrs: SavedPqrs.fromJson(json["savedPqrs"]),
  );

  Map<String, dynamic> toJson() => {
    "savedPqrs": savedPqrs?.toJson(),
  };
}

class SavedPqrs {
  SavedPqrs({
    this.supportType,
    this.subject,
    this.message,
    this.identity,
    this.status,
    this.seller,
    this.id,
    this.options,
  });

  String? supportType;
  String? subject;
  String? message;
  bool? identity;
  String? status;
  String? seller;
  int? id;
  Options? options;

  factory SavedPqrs.fromJson(Map<String, dynamic> json) => SavedPqrs(
    supportType: json["supportType"],
    subject: json["subject"],
    message: json["message"],
    identity: json["identity"],
    status: json["status"],
    seller: json["seller"],
    id: json["id"],
    options: Options.fromJson(json["options"]),
  );

  Map<String, dynamic> toJson() => {
    "supportType": supportType,
    "subject": subject,
    "message": message,
    "identity": identity,
    "status": status,
    "seller": seller,
    "id": id,
    "options": options?.toJson(),
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
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class TypeSupport {
  String? typeSupport;
  String? sendTypeSupport;
  bool selected;

  TypeSupport({
    this.typeSupport,
    this.sendTypeSupport,
    this.selected = false
  });

}

