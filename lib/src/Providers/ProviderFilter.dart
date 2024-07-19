import 'package:flutter/material.dart';
import 'package:wawamko/src/Models/SubCategory.dart';


class ProviderFilter with ChangeNotifier {



  List<SubCategory> _ltsSubCategory = [
    SubCategory(id: 1, subcategory: 'SubCategory 1', status: 'Active'),
    SubCategory(id: 2, subcategory: 'SubCategory 2', status: 'Active'),
    SubCategory(id: 3, subcategory: 'SubCategory 3', status: 'Active'),
    SubCategory(id: 4, subcategory: 'SubCategory 4', status: 'Active'),
    SubCategory(id: 5, subcategory: 'SubCategory 5', status: 'Active'),
  ];


  List<SubCategory> get ltsSubCategory => _ltsSubCategory;






}