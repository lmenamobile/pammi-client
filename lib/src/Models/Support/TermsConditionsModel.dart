// To parse this JSON data, do
//
//     final termsConditionsResponse = termsConditionsResponseFromJson(jsonString);

import 'dart:convert';

TermsConditionsResponse termsConditionsResponseFromJson(String str) => TermsConditionsResponse.fromJson(json.decode(str));

String termsConditionsResponseToJson(TermsConditionsResponse data) => json.encode(data.toJson());

class TermsConditionsResponse {
  TermsConditionsResponse({
    this.code,
    this.message,
    this.status,
    this.data,
  });

  int code;
  String message;
  bool status;
  Data data;

  factory TermsConditionsResponse.fromJson(Map<String, dynamic> json) => TermsConditionsResponse(
    code: json["code"],
    message: json["message"],
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

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
    this.terms,
  });

  int totalPages;
  int currentPage;
  List<Term> terms;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalPages: json["totalPages"],
    currentPage: json["currentPage"],
    terms: List<Term>.from(json["items"].map((x) => Term.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalPages": totalPages,
    "currentPage": currentPage,
    "terms": List<dynamic>.from(terms.map((x) => x.toJson())),
  };
}

class Term {
  Term({
    this.id,
    this.name,
    this.fileType,
    this.moduleType,
    this.url,
    this.visible,
    this.country,
    this.status,
    this.createdAt,
  });

  int id;
  String name;
  String fileType;
  String moduleType;
  String url;
  bool visible;
  Country country;
  String status;
  DateTime createdAt;

  factory Term.fromJson(Map<String, dynamic> json) => Term(
    id: json["id"],
    name: json["name"],
    fileType: json["fileType"],
    moduleType: json["moduleType"],
    url: json["url"],
    visible: json["visible"],
    country: Country.fromJson(json["country"]),
    status: json["status"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "fileType": fileType,
    "moduleType": moduleType,
    "url": url,
    "visible": visible,
    "country": country.toJson(),
    "status": status,
    "createdAt": createdAt.toIso8601String(),
  };
}

class Country {
  Country({
    this.id,
    this.country,
    this.callingCode,
    this.flag,
    this.currency,
    this.options,
  });

  String id;
  String country;
  String callingCode;
  String flag;
  String currency;
  Options options;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    id: json["id"],
    country: json["country"],
    callingCode: json["callingCode"],
    flag: json["flag"],
    currency: json["currency"],
    options: Options.fromJson(json["options"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "country": country,
    "callingCode": callingCode,
    "flag": flag,
    "currency": currency,
    "options": options.toJson(),
  };
}

class Options {
  Options({
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  String status;
  DateTime createdAt;
  DateTime updatedAt;

  factory Options.fromJson(Map<String, dynamic> json) => Options(
    status: json["status"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
