

import '../../domain/entities/banner.dart';

class BannerMapper {
  static Banners bannerJsonToEntity(Map<String, dynamic> json) {
    return Banners(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      position: json['position'],
      image: json['image'],
      type: json['type'],
    );
  }
}