import 'package:flutter/material.dart';

import '../../domain/domain.dart';

class DepartmentProvider extends ChangeNotifier {

  List<Department> _departments = [];
  List<Department> get departments => _departments;

  void setDepartments(List<Department> departments) {
    _departments = departments;
    notifyListeners();
  }

}