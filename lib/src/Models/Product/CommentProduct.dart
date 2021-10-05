import 'package:wawamko/src/Models/Product/UserComment.dart';
import 'package:wawamko/src/Models/User.dart';

class CommentProduct {
  CommentProduct({
    this.id,
    this.comment,
    this.qualification,
    this.date,
    this.user
  });

  int id;
  String comment;
  String qualification;
  DateTime date;
  UserComment user;

  factory CommentProduct.fromJson(Map<String, dynamic> json) => CommentProduct(
    id: json["id"],
    comment: json["comment"],
    qualification: json["qualification"].toString(),
    date: DateTime.parse(json["options"]["createdAt"]),
    user: json["user"]!=null?UserComment.fromJson(json["user"]):UserComment.fromJson(json["seller"])
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "comment": comment,
    "qualification": qualification,
    "date": date.toIso8601String(),
  };
}