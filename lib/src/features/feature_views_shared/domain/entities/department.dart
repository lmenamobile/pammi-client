
import '../../../feature_department_categories/domain/domain.dart';

class Department {
  final int id;
  final String department;
  final String image;
  final String status;
  final String createdAt;
  final List<Category> categories;

  Department({
    required this.id,
    required this.department,
    required this.image,
    required this.status,
    required this.createdAt,
    this.categories = const [],
  });

  Department copyWith({
    int? id,
    String? department,
    String? image,
    String? status,
    String? createdAt,
    List<Category>? categories,
  }) {
    return Department(
      id: id ?? this.id,
      department: department ?? this.department,
      image: image ?? this.image,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      categories: categories ?? this.categories,
    );
  }

  @override
  String toString() {
    return 'Department(id: $id, department: $department, image: $image, status: $status, createdAt: $createdAt,'
        ' categories: $categories)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Department &&
        other.id == id &&
        other.department == department &&
        other.image == image &&
        other.status == status &&
        other.createdAt == createdAt;
  }


}