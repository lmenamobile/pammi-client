import 'package:flutter/material.dart';

import '../../domain/domain.dart';

class CategoriesProvider extends ChangeNotifier {

   final CategoryRepository _repository;

  CategoriesProvider({required CategoryRepository repository}) : _repository = repository;

  List<Category> _categories = [];
  bool _isLoading = false;
  String _error = '';
  int _currentPage = 0;
  bool _hasMorePages = true;
  String _currentFilter = '';
  int? _departmentId;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get hasMorePages => _hasMorePages;

  Future<void> loadCategories({int? departmentId, String filter = '', bool refresh = false}) async {
    if (refresh) {
      resetPagination();
    }

    if (_isLoading || !_hasMorePages) return;

    _isLoading = true;
    _error = '';
    _currentFilter = filter;
    _departmentId = departmentId;
    notifyListeners();

    try {
      final newCategories = await _repository.getCategoriesByDepartment(_departmentId!, _currentFilter, _currentPage);
      if (newCategories.isEmpty) {
        _hasMorePages = false;
      } else {
        _categories.addAll(newCategories);
        _currentPage++;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetPagination() {
    _categories = [];
    _currentPage = 0;
    _hasMorePages = true;
  }

  void clearDepartmentId() {
    _departmentId = null;
  }

  Future<void> refreshCategories() async {
    resetPagination();
    await loadCategories(departmentId: _departmentId, filter: _currentFilter, refresh: true);
  }

  Future<void> loadMoreCategories() async {
    if (!_isLoading && _hasMorePages) {
      await loadCategories(departmentId: _departmentId, filter: _currentFilter);
    }
  }





}