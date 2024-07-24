
import '../../domain/domain.dart';

class SubCategoryMapper {

  static SubCategory subCategoryFromJsonToEntity(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'],
      subCategory: json['subcategory'],
    );
  }
}