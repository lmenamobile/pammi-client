import 'dart:convert';

ResponseSubThemes responseSubThemesFromJson(String str) => ResponseSubThemes.fromJson(json.decode(str));

String responseSubThemesToJson(ResponseSubThemes data) => json.encode(data.toJson());

class ResponseSubThemes {
  ResponseSubThemes({
    this.data,
  });

  Data? data;

  factory ResponseSubThemes.fromJson(Map<String, dynamic> json) => ResponseSubThemes(
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
    this.itemsQuestions,
  });

  int? totalPages;
  int? currentPage;
  List<ItemQuestionsSubTheme>? itemsQuestions;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalPages: json["totalPages"],
    currentPage: json["currentPage"],
    itemsQuestions: List<ItemQuestionsSubTheme>.from(json["items"].map((x) => ItemQuestionsSubTheme.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalPages": totalPages,
    "currentPage": currentPage,
    "items": List<dynamic>.from(itemsQuestions!.map((x) => x.toJson())),
  };
}

class ItemQuestionsSubTheme {
  ItemQuestionsSubTheme({
    this.id,
    this.question,
    this.response,
    this.userType,
    this.typology,
    this.module,
    this.subtheme,
    this.status,
    this.createdAt,
  });

  int? id;
  String? question;
  String? response;
  String? userType;
  String? typology;
  String? module;
  Subtheme? subtheme;
  String? status;
  DateTime? createdAt;

  factory ItemQuestionsSubTheme.fromJson(Map<String, dynamic> json) => ItemQuestionsSubTheme(
    id: json["id"],
    question: json["question"],
    response: json["response"],
    userType: json["userType"],
    typology: json["typology"],
    module: json["module"],
    subtheme: Subtheme.fromJson(json["subtheme"]),
    status: json["status"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "response": response,
    "userType": userType,
    "typology": typology,
    "module": module,
    "subtheme": subtheme?.toJson(),
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
  };
}

class Subtheme {
  Subtheme({
    this.id,
    this.subtheme,
    this.image,
    this.options,
    this.theme,
  });

  int? id;
  String? subtheme;
  String? image;
  Options? options;
  Theme? theme;

  factory Subtheme.fromJson(Map<String, dynamic> json) => Subtheme(
    id: json["id"],
    subtheme: json["subtheme"],
    image: json["image"],
    options: Options.fromJson(json["options"]),
    theme: Theme.fromJson(json["theme"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "subtheme": subtheme,
    "image": image,
    "options": options?.toJson(),
    "theme": theme?.toJson(),
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

class Theme {
  Theme({
    this.id,
    this.theme,
    this.options,
  });

  int? id;
  String? theme;
  Options? options;

  factory Theme.fromJson(Map<String, dynamic> json) => Theme(
    id: json["id"],
    theme: json["theme"],
    options: Options.fromJson(json["options"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "theme": theme,
    "options": options?.toJson(),
  };
}
