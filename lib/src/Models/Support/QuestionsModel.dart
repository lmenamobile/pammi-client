// To parse this JSON data, do
//
//     final questionsResponse = questionsResponseFromJson(jsonString);

import 'dart:convert';

QuestionsResponse questionsResponseFromJson(String str) => QuestionsResponse.fromJson(json.decode(str));

String questionsResponseToJson(QuestionsResponse data) => json.encode(data.toJson());

class QuestionsResponse {
  QuestionsResponse({
    this.code,
    this.status,
    this.data,
  });

  int code;
  bool status;
  Data data;

  factory QuestionsResponse.fromJson(Map<String, dynamic> json) => QuestionsResponse(
    code: json["code"],
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.totalPages,
    this.currentPage,
    this.questions,
  });

  int totalPages;
  int currentPage;
  List<Question> questions;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalPages: json["totalPages"],
    currentPage: json["currentPage"],
    questions: List<Question>.from(json["items"].map((x) => Question.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalPages": totalPages,
    "currentPage": currentPage,
    "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
  };
}

class Question {
  Question({
    this.id,
    this.question,
    this.answer,
    this.moduleType,
    this.country,
    this.status,
    this.createdAt,
  });

  int id;
  String question;
  String answer;
  String moduleType;
  Country country;
  String status;
  DateTime createdAt;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json["id"],
    question: json["question"],
    answer: json["answer"],
    moduleType: json["moduleType"],
    country: Country.fromJson(json["country"]),
    status: json["status"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "answer": answer,
    "moduleType": moduleType,
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
