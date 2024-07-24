
import '../../../feature_department_categories/domain/domain.dart';
import '../../../feature_department_categories/infrastructure/infrastructure.dart';
import '../../domain/domain.dart';

class DepartmentMapper {

  static Department departmentJsonToEntity(Map<String, dynamic> json) {
    return Department(
        id: json['id'],
        department: json['department'],
        image: json['image'],
        status: json['status'],
        createdAt: json['createdAt'],
        categories: json['categories'] != null ? json['categories'].map<Category>((category) => CategoryMapper.categoryFromJsonToEntity(category)).toList() : []
    );
  }

}