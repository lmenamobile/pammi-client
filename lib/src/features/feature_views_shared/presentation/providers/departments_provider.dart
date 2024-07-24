import 'package:flutter/material.dart';
import '../../../../config/config.dart';
import '../../domain/domain.dart';


class DepartmentProvider extends ChangeNotifier {
  final DepartmentRepository _repository;

  List<Department> _departments = [];
  List<Department> _homeDepartments = [];
  bool _isLoading = false;
  String _error = '';
  int _currentPage = 0;
  bool _hasMorePages = true;
  bool _isHomeListCreated = false;
  String _currentFilter = '';

  DepartmentProvider({required DepartmentRepository repository}) : _repository = repository;


  String? selectedDepartment;
  String? selectedCategory;
  String? selectedSubcategory;


  void selectDepartment(String departmentName) {
    selectedDepartment = departmentName;
    selectedCategory = null;
    selectedSubcategory = null;
    notifyListeners();
  }

  void selectCategory(String categoryName) {
    selectedCategory = categoryName;
    selectedSubcategory = null;
    notifyListeners();
  }

  void selectSubcategory(String subcategoryName) {
    selectedSubcategory = subcategoryName;
    notifyListeners();
  }

  List<Department> get departments => _departments;
  List<Department> get homeDepartments => _homeDepartments;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get hasMorePages => _hasMorePages;

  Future<void> loadDepartments({String filter = '', bool refresh = false}) async {
    if (refresh) {
      resetPagination();
    }

    if (_isLoading || !_hasMorePages) return;

    _isLoading = true;
    _error = '';
    _currentFilter = filter;
    notifyListeners();

    try {
      final newDepartments = await _repository.getDepartments(_currentFilter, _currentPage);
      if (newDepartments.isEmpty) {
        _hasMorePages = false;
      } else {
        _departments.addAll(newDepartments);
        _currentPage++;
        if (!_isHomeListCreated) {
          _createHomeDepartmentsList();
          _isHomeListCreated = true;
        }
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _createHomeDepartmentsList() {
    List<Department> newHomeDepartments = [];
    if (_departments.length > 7) {
      newHomeDepartments = _departments.sublist(0, 7);
    } else {
      newHomeDepartments = List.from(_departments);
    }
    newHomeDepartments.add(Department(
      id: 0,
      department: "Todos",
      image: ApiRoutes.assetCategories,
      status: 'active',
      createdAt: DateTime.now().toIso8601String(),
    ));
    _homeDepartments = newHomeDepartments;
    notifyListeners();
  }

  void resetPagination() {
    _currentPage = 0;
    _departments.clear();
    _hasMorePages = true;
    _currentFilter = '';
    notifyListeners();
  }

  Future<void> refreshDepartments() async {
    await loadDepartments(refresh: true);
  }

  Future<void> loadMoreDepartments() async {
    if (!_isLoading && _hasMorePages) {
      await loadDepartments(filter: _currentFilter);
    }
  }

}