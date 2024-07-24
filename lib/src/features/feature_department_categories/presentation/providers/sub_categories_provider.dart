import 'package:flutter/material.dart';

import '../../domain/domain.dart';

class SubCategoriesProvider extends ChangeNotifier {

  final SubCategoryRepository _subCategoryRepository;

  SubCategoriesProvider({required SubCategoryRepository subCategoryRepository}) : _subCategoryRepository = subCategoryRepository;

  List<SubCategory> _subCategories = [];
  bool _isLoading = false;
  String _error = '';
  int _currentPage = 0;
  bool _hasMorePages = true;
  String _currentFilter = '';
  int? _categoryId;

  List<SubCategory> get subCategories => _subCategories;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get hasMorePages => _hasMorePages;

  Future<void> loadSubCategories({int? categoryId, String filter = '', bool refresh = false}) async {
    if (refresh) {
      resetPagination();
    }

    if (_isLoading || !_hasMorePages) return;

    _isLoading = true;
    _error = '';
    _currentFilter = filter;
    _categoryId = categoryId;
    notifyListeners();

    try {
      final newSubCategories = await _subCategoryRepository
          .getSubCategoriesByCategory(
          _categoryId!, _currentFilter, _currentPage);
      if (newSubCategories.isEmpty) {
        _hasMorePages = false;
      } else {
        _subCategories.addAll(newSubCategories);
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
    _subCategories = [];
    _currentPage = 0;
    _hasMorePages = true;
  }

  void clearCategoryId() {
    _categoryId = null;
  }

  Future<void> refreshSubCategories() async {
    resetPagination();
    await loadSubCategories(categoryId: _categoryId, filter: _currentFilter, refresh: true);
  }

  Future<void> loadMoreSubCategories() async {
    if (!_isLoading && _hasMorePages) {
      await loadSubCategories(categoryId: _categoryId, filter: _currentFilter);
    }
  }

}