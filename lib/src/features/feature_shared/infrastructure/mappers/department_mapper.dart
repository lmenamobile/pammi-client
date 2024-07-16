
import '../../domain/domain.dart';

class DepartmentMapper {
  static Department departmentJsonToEntity(Map<String, dynamic> json) {
    return Department(
        id: json['id'],
        department: json['department'],
        image: json['image'],
        status: json['status'],
        createdAt: json['createdAt']
    );
  }

}