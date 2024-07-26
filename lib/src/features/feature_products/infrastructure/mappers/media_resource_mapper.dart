


import '../../domain/domain.dart';

class MediaResourceMapper{
  static MediaResourceReference mediaResourceFromJsonToEntity(Map<String, dynamic> json) {
    return MediaResourceReference(
      url: json["url"],
      mediaType: json["type"],
    );
  }
}