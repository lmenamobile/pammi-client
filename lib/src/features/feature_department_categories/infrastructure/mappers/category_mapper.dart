
import '../../domain/domain.dart';

class CategoryMapper {

  static Category categoryFromJsonToEntity(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      category: json['category'],
      color: json['color'],
      image: json['image'],
    );
  }
}