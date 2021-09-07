class DataMessage {
  DataMessage({
    this.id,
    this.state,
    this.type,
    this.message,
    this.typeUser,
    this.dates,
  });

  int id;
  String state;
  String type;
  String message;
  String typeUser;
  Dates dates;

  factory DataMessage.fromJson(Map<String, dynamic> json) => DataMessage(
    id: json["id"],
    state: json["state"],
    type: json["type"],
    message: json["message"],
    typeUser: json["typeUser"],
    dates: Dates.fromJson(json["options"]),
  );

}

class Dates {
  Dates({
    this.createdAt,
  });

  DateTime createdAt;

  factory Dates.fromJson(Map<String, dynamic> json) => Dates(
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt.toIso8601String(),
  };
}
