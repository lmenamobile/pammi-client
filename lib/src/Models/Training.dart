class Training {
  Training({
    this.id,
    this.training,
    this.url,
    this.moduleType,
    this.status,
  });

  int id;
  String training;
  String url;
  String moduleType;
  String status;

  factory Training.fromJson(Map<String, dynamic> json) => Training(
    id: json["id"],
    training: json["training"],
    url: json["url"],
    moduleType: json["moduleType"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "training": training,
    "url": url,
    "moduleType": moduleType,
    "status": status,
  };
}