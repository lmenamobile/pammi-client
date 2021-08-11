class Notifications {
  Notifications({
    this.id,
    this.title,
    this.image,
    this.message,
    this.state,
    this.sendTo,
    this.type,
    this.status,
    this.createdAt,
    this.isSelected
  });

  int id;
  String title;
  String image;
  String message;
  String state;
  String sendTo;
  String type;
  String status;
  DateTime createdAt;
  bool isSelected = false;

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
    id: json["id"],
    title: json["title"],
    image: json["image"],
    message: json["message"],
    state: json["state"],
    sendTo: json["sendTo"],
    type: json["type"],
    status: json["status"],
    createdAt: DateTime.parse(json["createdAt"]),
    isSelected: false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
    "message": message,
    "state": state,
    "sendTo": sendTo,
    "type": type,
    "status": status,
    "createdAt": createdAt.toIso8601String(),
  };
}
