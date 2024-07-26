import 'package:flutter/material.dart';

import '../../domain/domain.dart';

class ProductsProvider extends ChangeNotifier {
  final ProductRepository _repository;

  ProductsProvider({required ProductRepository repository})
      : _repository = repository;

  List<Product> _products = [];
  bool _isLoading = false;
  String _error = '';
  int _currentPage = 0;
  bool _hasMorePages = true;
  int? _branProviderId;
  int? _categoryId;
  int? _subCategoryId;
  int? _brandId;
  List<int> _filterIds = [];

  List<Product> get products => _products;

  bool get isLoading => _isLoading;

  String get error => _error;

  Future<void> loadProducts({
    int? brandProviderId,
    int? categoryId,
    int? subCategoryId,
    int? brandId,
    List<int>? filterIds,
    bool refresh = false,
  }) async {
    if (refresh) {
      resetPagination();
    }

    if (_isLoading || !_hasMorePages) return;

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      if (brandProviderId != null) _branProviderId = brandProviderId;
      if (categoryId != null) _categoryId = categoryId;
      if (subCategoryId != null) _subCategoryId = subCategoryId;
      if (brandId != null) _brandId = brandId;
      if (filterIds != null) _filterIds = filterIds;

      final newProducts = await _repository.getProducts(
        _branProviderId,
        _categoryId,
        _subCategoryId,
        _currentPage,
        _filterIds,
      );

      if (newProducts.isEmpty) {
        _hasMorePages = false;
      } else {
        _products.addAll(newProducts);
        _currentPage++;
      }
    } catch (e) {
      print("error: $e");
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetPagination() {
    _products = [];
    _currentPage = 0;
    _hasMorePages = true;
  }

  Future<void> refreshProducts() async {
    resetPagination();
    await loadProducts(
        brandProviderId: _branProviderId,
        categoryId: _categoryId,
        subCategoryId: _subCategoryId,
        brandId: _brandId,
        filterIds: _filterIds,
        refresh: true);
  }

  Future<void> loadMoreProducts() async {
    if (!_isLoading && _hasMorePages) {
      await loadProducts(
          brandProviderId: _branProviderId,
          categoryId: _categoryId,
          subCategoryId: _subCategoryId,
          brandId: _brandId,
          filterIds: _filterIds);
    }
  }
}
