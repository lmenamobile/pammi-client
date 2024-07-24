
import '../../domain/domain.dart';
import '../infrastructure.dart';

class CategoryMapper {

  static Category categoryFromJsonToEntity(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      category: json['category'],
      color: json['color'],
      image: json['image'],
      subCategories: json['subcategories'] != null ? json['subcategories'].map<SubCategory>((subCategory) => SubCategoryMapper.subCategoryFromJsonToEntity(subCategory)).toList() : [],
    );
  }
}