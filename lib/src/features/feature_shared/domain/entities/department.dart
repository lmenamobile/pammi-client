
class Department {
  final int id;
  final String department;
  final String image;
  final String status;
  final String createdAt;

  Department({
    required this.id,
    required this.department,
    required this.image,
    required this.status,
    required this.createdAt,
  });

  Department copyWith({
    int? id,
    String? department,
    String? image,
    String? status,
    String? createdAt,
  }) {
    return Department(
      id: id ?? this.id,
      department: department ?? this.department,
      image: image ?? this.image,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Department(id: $id, department: $department, image: $image, status: $status, createdAt: $createdAt)';
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