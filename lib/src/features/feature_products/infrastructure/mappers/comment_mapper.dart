

import '../../domain/domain.dart';

class CommentMapper {

  static CommentReference commentFromJsonEntity(Map<String, dynamic> json) {
    return CommentReference(
      comment: json["comment"],
      rating: double.parse(json["qualification"].toString()),
      dateComment: DateTime.parse(json["options"]["createdAt"]),
    );
  }
}