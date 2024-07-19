
import '../../domain/domain.dart';

class BrandMapper {

  static Brand brandJsonToEntity(Map<String, dynamic> json) {
    return Brand(
      id: json['id'],
      brand: json['brand'],
      image: json['image'],
    );
  }
}