
class TermsAndConditions {
  TermsAndConditions({
    this.id,
    this.name,
    this.fileType,
    this.moduleType,
    this.url,
    this.visible,
    this.status,
    this.createdAt,
  });

  int? id;
  String? name;
  String? fileType;
  String? moduleType;
  String? url;
  bool? visible;
  String? status;
  DateTime? createdAt;

  factory TermsAndConditions.fromJson(Map<String, dynamic> json) => TermsAndConditions(
    id: json["id"],
    name: json["name"],
    fileType: json["fileType"],
    moduleType: json["moduleType"],
    url: json["url"],
    visible: json["visible"],
    status: json["status"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

}

