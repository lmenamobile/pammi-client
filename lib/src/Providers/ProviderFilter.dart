import 'package:flutter/material.dart';
import 'package:wawamko/src/Models/SubCategory.dart';

import '../Models/Brand.dart';

class ProviderFilter with ChangeNotifier {

  List<Brand> _ltsBrands = [];

  List<Brand> _filteredBrands = [];

  List<SubCategory> _ltsSubCategory = [
    SubCategory(id: 1, subcategory: 'SubCategory 1', status: 'Active'),
    SubCategory(id: 2, subcategory: 'SubCategory 2', status: 'Active'),
    SubCategory(id: 3, subcategory: 'SubCategory 3', status: 'Active'),
    SubCategory(id: 4, subcategory: 'SubCategory 4', status: 'Active'),
    SubCategory(id: 5, subcategory: 'SubCategory 5', status: 'Active'),
  ];

  List<Brand> get ltsBrands => _ltsBrands;

  List<Brand> get filteredBrands => _filteredBrands;

  List<SubCategory> get ltsSubCategory => _ltsSubCategory;

  void setBrands(List<Brand> value) {
    _ltsBrands = value;
    _filteredBrands = value;
    notifyListeners();
  }

  void filterBrands(String query) {
    if (query.isEmpty) {
      _filteredBrands = _ltsBrands;
    } else {
      _filteredBrands = _ltsBrands.where((brand) => (brand.brand?.toLowerCase() ?? '').contains(query.toLowerCase())).toList();
    }
    notifyListeners();
  }


}