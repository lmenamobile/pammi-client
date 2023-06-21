class Themes {
  Themes({
    this.id,
    this.theme,
    this.subthemes,
    this.status,
    this.createdAt,
  });

  int? id;
  String? theme;
  List<Subtheme>? subthemes;
  String? status;
  DateTime? createdAt;

  factory Themes.fromJson(Map<String, dynamic> json) => Themes(
    id: json["id"] == null ? null : json["id"],
    theme: json["theme"] == null ? null : json["theme"],
    subthemes: json["subthemes"] == null ? null : List<Subtheme>.from(json["subthemes"].map((x) => Subtheme.fromJson(x))),
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

class Subtheme {
  Subtheme({
    this.id,
    this.subtheme,
    this.image,
    this.options,
  });

  int? id;
  String? subtheme;
  String? image;
  Options? options;

  factory Subtheme.fromJson(Map<String, dynamic> json) => Subtheme(
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
