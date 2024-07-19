import 'package:flutter/material.dart';

import '../../domain/domain.dart';

class BrandsProvider extends ChangeNotifier {
  final BrandRepository _repository;

  List<Brand> _brands = [];
  List<Brand> _homeBrands = [];
  bool _isLoading = false;
  String _error = '';
  int _currentPage = 0;
  bool _hasMorePages = true;
  bool _isHomeListCreated = false;
  String _currentFilter = '';

  BrandsProvider({required BrandRepository repository}) : _repository = repository;

  List<Brand> get brands => _brands;
  List<Brand> get homeBrands => _homeBrands;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get hasMorePages => _hasMorePages;

  Future<void> loadBrands({String filter = '', bool refresh = false}) async {
    if (refresh) {
      resetPagination();
    }

    if (_isLoading || !_hasMorePages) return;

    _isLoading = true;
    _error = '';
    _currentFilter = filter;
    notifyListeners();

    try {
      final newBrands = await _repository.getBrands(_currentFilter, _currentPage);
      if (newBrands.isEmpty) {
        _hasMorePages = false;
      } else {
        _brands.addAll(newBrands);
        _currentPage++;
        if (!_isHomeListCreated) {
          _createHomeBrandsList();
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

  void _createHomeBrandsList() {
    List<Brand> newHomeBrands = [];
    if (_brands.length > 7) {
      newHomeBrands = _brands.sublist(0, 7);
    } else {
      newHomeBrands = _brands;
    }
    _homeBrands = newHomeBrands;
    notifyListeners();
  }

  void resetPagination() {
    _currentPage = 0;
    _hasMorePages = true;
    _brands = [];
    _homeBrands = [];
    _isHomeListCreated = false;
  }
}